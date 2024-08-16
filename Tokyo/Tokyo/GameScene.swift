import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    var entityManager: SKEntityManager?
    var right_button = SKSpriteNode(imageNamed: "right")
    var left_button = SKSpriteNode(imageNamed: "left")
    var jump_button = SKSpriteNode(imageNamed: "jump")
    var enemies:[GhostEntity] = []
    var boss:[BossEntity] = []
    public var stateMachine : GKStateMachine?
    public var stateMachineEnemy : GKStateMachine?
    private var lastUpdateTime : TimeInterval = 0
    weak var playerEntity: PlayerEntity?
    var temporaryBlock: TemporaryBlockEntity?
        
    var rightButtonPressed = false
    var leftButtonPressed = false
    var songOneIsPlaying = true
    var audioPlayerOne = AudioManager.shared
    var audioPlayerTwo = AudioManager.shared
   /* private let playerLight = SKLightNode() */ // Light node to follow the player
    var textBox = TextDialogue(sprite: SKSpriteNode(imageNamed: "textBox1"), label: SKLabelNode(text: ""))
    var isTextBoxHidden = true
    var pauseButton = SKSpriteNode(imageNamed: "pause")
    var pausePopUp: PausePopUp?
    
    
    
    override func sceneDidLoad() {
        audioPlayerOne.playLevelOneSong()
        self.physicsWorld.contactDelegate = self
        
        entityManager = SKEntityManager(scene: self)
        //Adicionando Level02 (CÓDIGO LUAN)
        
        initializeBackground()
        //        AudioManager.shared.playLevelOneSong()
        
        textBox.isHidden = true
        self.camera?.setScale(0.50)
        
        let scenarioEntity = TilesEntity(named: "Level02.sks", entityManager: entityManager!)
        entityManager?.add(entity: scenarioEntity)
        
        print(left_button.position)
        
        let cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        self.camera?.setScale(0.50)
        //FIM DO CODIGO
        
        let numberOfFireflies = 300  // Número de partículas que você quer criar
        
        for _ in 0..<numberOfFireflies {
            let sparkleEmitter = createSparkleEffect()
            
            // Define uma posição aleatória dentro dos limites da cena
            let randomX = CGFloat.random(in: -960...960)
            let randomY = CGFloat.random(in: -1600...100)
            sparkleEmitter.position = CGPoint(x: randomX, y: randomY)
            
            // Adiciona o emissor de partículas à cena
            addChild(sparkleEmitter)
            
            
        }
        
        let playerEntity = PlayerEntity(entityManager: entityManager!)
        entityManager?.add(entity: playerEntity)
        self.playerEntity = playerEntity
        playerEntity.stateComponent?.stateMachine.enter(PlayerIdle.self)
        
        
        let keyItem = ItemEntity(position: CGPoint(x: 0, y: -530), size: CGSize(width: 100, height: 110), entityManager: entityManager!, sprite: "key")
        keyItem.identityComponent?.name(name: "key")
        entityManager?.add(entity: keyItem)
        
        let sign = SignEntity(position: CGPoint(x: 1500, y: -1255))
        entityManager?.add(entity: sign)
        
        
        for i in 0..<3{
            let xDistance = 90 * i
            let temporaryBlock = TemporaryBlockEntity(position: CGPoint(x: 80 - xDistance, y: -1280), entityManager: entityManager!)
            entityManager?.add(entity: temporaryBlock)
        }
        
        let temporaryBlock1 = TemporaryBlockEntity(position: CGPoint(x: 100, y: -760), entityManager: entityManager!)
        entityManager?.add(entity: temporaryBlock1)
        let temporaryBlock2 = TemporaryBlockEntity(position: CGPoint(x: -80, y: -680), entityManager: entityManager!)
        entityManager?.add(entity: temporaryBlock2)
        let temporaryBlock3 = TemporaryBlockEntity(position: CGPoint(x: 80, y: -640), entityManager: entityManager!)
        entityManager?.add(entity: temporaryBlock3)
        
        setupButtons()
        addCherries()
        addEventTriggers()
        adjustButtonLayout()
        ghostAdd()
        addCheckpoints()
//        setupPlayerLight()  // Set up the light node
        setupPauseButton()
        
        let pausePopUp = PausePopUp()
        self.pausePopUp = pausePopUp
    }
    
    // Function to set up the light node
//    private func setupPlayerLight() {
//        playerLight.categoryBitMask = 1  // Define a categoria da luz
//        playerLight.lightColor = .white  // Cor da luz
//        playerLight.ambientColor = .black // Cor do ambiente ao redor (escurecer)
//        playerLight.falloff = 1  // Quão rápido a luz escurece
//        playerLight.isEnabled = true
//        
//        self.addChild(playerLight)  // Adiciona a luz à cena
//        
//        
//    }
    func setupPauseButton(){
        guard let camera = self.camera else { return }
        let cameraFrame = camera.calculateAccumulatedFrame()
        
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: 32, height: 32)
        pauseButton.texture?.filteringMode = .nearest
        pauseButton.position = CGPoint(x: cameraFrame.maxX + 195, y: cameraFrame.maxY + 100)
        pauseButton.zPosition = 10
        pauseButton.setScale(2)
        self.camera?.addChild(pauseButton)
    }
    
    
    func setupButtons(){
        
        right_button.name = "right_button"
        right_button.texture?.filteringMode = .nearest
        self.camera?.addChild(right_button)
        
        left_button.name = "left_button"
        left_button.texture?.filteringMode = .nearest
        self.camera?.addChild(left_button)
        
        jump_button.name = "jump_button"
        jump_button.texture?.filteringMode = .nearest
        self.camera?.addChild(jump_button)
        
        textBox.sprite.texture?.filteringMode = .nearest
        self.camera?.addChild(textBox)
        
    }
    
    func adjustButtonLayout() {
        guard let camera = self.camera else { return }
        let buttonSize = CGSize(width: 80, height: 80)
        
        right_button.size = buttonSize
        left_button.size = buttonSize
        jump_button.size = buttonSize
        
        let cameraFrame = camera.calculateAccumulatedFrame()
        
        left_button.position = CGPoint(x: cameraFrame.minX-230, y: cameraFrame.minY - 100 )
        right_button.position = CGPoint(x: left_button.position.x + buttonSize.width+30, y: left_button.position.y)
        
        jump_button.position = CGPoint(x: cameraFrame.maxX+220, y:left_button.position.y)
        
//        textBox.sprite.size = CGSize(width: 500, height: 500)
        textBox.position = CGPoint(x: 0, y: 60)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
//        adjustButtonLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            let location = touch.location(in: camera!)
            
            if pauseButton.contains(location) {
                isPaused.toggle()
                
//                if (isPaused) {
//                    self.pausePopUp?.show(in: self)
//                } else {
//                    self.pausePopUp?.hide()
//                }
                
            }
        }
        
        captureInput(touches: touches, isTouching: true)
    }
    
    
    
 
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        captureInput(touches: touches, isTouching: false)
        
        if !rightButtonPressed && !leftButtonPressed{
            playerEntity?.stateComponent?.stateMachine.enter(PlayerIdle.self)
            playerEntity?.moveComponent?.direction = .none
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        updateBackgroundPosition()
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        
        let dt = currentTime - self.lastUpdateTime
        
        if let entities = entityManager?.entities {
            for entity in entities {
                entity.update(deltaTime: dt)
            }
        }
        
        if let playerNode = playerEntity?.spriteNode {
            self.camera?.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 35)
//            playerLight.position = playerNode.position  // Make the light follow the player
        }
        
        self.lastUpdateTime = currentTime
    }
    
    public func captureInput(touches: Set<UITouch>, isTouching: Bool) {
        guard let camera else { return }
        if let location = touches.first?.location(in: camera){
            if right_button.contains(location) {
                rightButtonPressed = isTouching
                if isTouching {
                    playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                    playerEntity?.moveComponent?.change(direction: .right)
                }
                else if !leftButtonPressed{
                    playerEntity?.moveComponent?.change(direction: .none)
                }
            }
            
            if left_button.contains(location) {
                leftButtonPressed = isTouching
                if isTouching {
                    playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                    playerEntity?.moveComponent?.change(direction: .left)
                }
                else if !rightButtonPressed{
                    playerEntity?.moveComponent?.change(direction: .none)
                }
            }
            
            if jump_button.contains(location) && isTouching {
                let horizontalDirection: CGFloat = rightButtonPressed ? 1 : (leftButtonPressed ? -1 : 0)
                playerEntity?.jump(horizontalDirection: horizontalDirection)
            }
        }
    }
    
    func gameOver() {
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .aspectFill
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view?.presentScene(newScene)
    }
    
    func createSparkleEffect() -> SKEmitterNode {
        let sparkleEmitter = SKEmitterNode()
        
        sparkleEmitter.particleTexture = SKTexture(imageNamed: "Firefly")  // Textura da partícula
        sparkleEmitter.particleColor = .yellow                           // Cor das partículas
        
        sparkleEmitter.particleBirthRate = 1                             // Taxa de geração das partículas
        sparkleEmitter.particleLifetime = 2                            // Tempo de vida das partículas
        sparkleEmitter.particleLifetimeRange = 1                       // Variação no tempo de vida
        
        sparkleEmitter.particlePositionRange = CGVector(dx: 10, dy: 10)  // Área de emissão das partículas
        sparkleEmitter.particleSpeed = 10                                // Velocidade das partículas
        sparkleEmitter.particleSpeedRange = 10                           // Variação na velocidade
        
        sparkleEmitter.emissionAngleRange = 360                          // Ângulo de emissão das partículas
        
        sparkleEmitter.particleScale = 0.4                               // Escala das partículas
        sparkleEmitter.particleScaleRange = 0.1                          // Variação na escala
        
        sparkleEmitter.particleAlpha = 1.0                               // Transparência das partículas
        sparkleEmitter.particleAlphaRange = 0.5                          // Variação na transparência
        sparkleEmitter.particleAlphaSpeed = -0.5                         // Velocidade de alteração da transparência (fade)
        
        sparkleEmitter.particleBlendMode = .add                          // Modo de mistura (efeito de brilho)
        
        // Ação de piscar das partículas
        sparkleEmitter.particleAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.1, duration: 0.3),
            SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        ])
        
        return sparkleEmitter
    }
    
    
    func initializeBackground() {
        //background adicionado à cena
        background = SKSpriteNode(imageNamed: "background1")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -5 // Coloque atrás dos outros nodes
        background.alpha = 0.6
        background.setScale(1)
        background.texture?.filteringMode = .nearest
        addChild(background)
    }
    
    func updateBackgroundPosition() {
        guard let playerNode = playerEntity?.spriteNode else { return }
        
        // Ajuste a posição do background com base na posição do player
        // Ajuste o fator de parallax para criar o efeito desejado
        let parallaxFactor: CGFloat = 0.5
        background.position = CGPoint(x: playerNode.position.x * parallaxFactor, y: playerNode.position.y * parallaxFactor)
    }
    
    func ghostAdd(){
        let ghost1 = GhostEntity(position: CGPoint(x: 180, y: -245), entityManager: entityManager!, spriteName: "yellowGhost")
        entityManager?.add(entity: ghost1)
        enemies.append(ghost1)
        ghost1.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path1 = ghost1.moveComponent?.moveGhost(points:[CGPoint(x: 700, y: -245), CGPoint(x: 700, y: -105), CGPoint(x: 180, y: -105), CGPoint(x: 180, y: -245)], duration: [2, 1, 2, 1], direction: .left) else {return}
        let actionSequence1 = SKAction.repeatForever(SKAction.sequence(path1))
        ghost1.wanderComponent?.wander(path: actionSequence1)
        
        let ghost2 = GhostEntity(position: CGPoint(x: -280, y: -105), entityManager: entityManager!, spriteName: "pinkGhost")
        entityManager?.add(entity: ghost2)
        enemies.append(ghost2)
        ghost2.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path2 = ghost2.moveComponent?.moveGhost2WayPoints(points:[CGPoint(x: -930, y: -105), CGPoint(x: -280, y: -105)], duration: [2.5, 2.5], direction: .left) else {return}
        let actionSequence2 = SKAction.repeatForever(SKAction.sequence(path2))
        ghost2.wanderComponent?.wander(path: actionSequence2)
        
        let ghost3 = GhostEntity(position: CGPoint(x: 500, y: -375), entityManager: entityManager!, spriteName: "redGhost")
        entityManager?.add(entity: ghost3)
        enemies.append(ghost3)
        ghost3.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path3 = ghost3.moveComponent?.moveGhost2WayPoints(points:[CGPoint(x: -840, y: -375), CGPoint(x: 500, y: -375)], duration: [4, 4], direction: .left) else {return}
        let actionSequence3 = SKAction.repeatForever(SKAction.sequence(path3))
        ghost3.wanderComponent?.wander(path: actionSequence3)
        
        let ghost4 = GhostEntity(position: CGPoint(x: -940, y: -1245), entityManager: entityManager!, spriteName: "blueGhost")
        entityManager?.add(entity: ghost4)
        enemies.append(ghost4)
        ghost4.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path4 = ghost4.moveComponent?.moveGhost2WayPoints(points:[CGPoint(x: -560, y: -1245), CGPoint(x: -940, y: -1245)], duration: [2.5, 2.5], direction: .right) else {return}
        let actionSequence4 = SKAction.repeatForever(SKAction.sequence(path4))
        ghost4.wanderComponent?.wander(path: actionSequence4)
        
        let ghost5 = GhostEntity(position: CGPoint(x: -920, y: -1095), entityManager: entityManager!, spriteName: "yellowGhost")
        entityManager?.add(entity: ghost5)
        enemies.append(ghost5)
        ghost5.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path5 = ghost5.moveComponent?.moveGhostMultipleWayPoints(points:[CGPoint(x: -920, y: -965), CGPoint(x: -790, y: -965), CGPoint(x:  -790, y: -845), CGPoint(x: -470, y: -845), CGPoint(x:  -470, y: -965), CGPoint(x: -670, y: -965), CGPoint(x: -670, y: -1095),  CGPoint(x: -920, y: -1080)], duration: [1, 2, 1.5, 2.5, 1, 2, 1, 2], direction: .left) else {return}
        let actionSequence5 = SKAction.repeatForever(SKAction.sequence(path5))
        ghost5.wanderComponent?.wander(path: actionSequence5)
        
        let ghost6 = GhostEntity(position: CGPoint(x: 80, y: -1095), entityManager: entityManager!, spriteName: "redGhost")
        entityManager?.add(entity: ghost6)
        enemies.append(ghost6)
        ghost6.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path6 = ghost6.moveComponent?.moveGhostMultipleWayPoints(points: [CGPoint(x: 485, y: -1095), CGPoint(x: 485, y: -970), CGPoint(x: 765, y: -970), CGPoint(x: 765, y: -795), CGPoint(x: 925, y: -795), CGPoint(x: 925, y: -1245), CGPoint(x: 640, y: -1245), CGPoint(x: 640, y: -970), CGPoint(x: 485, y: -970), CGPoint(x: 485, y: -1080), CGPoint(x: 80, y: -1080)], duration: [2, 1, 1.5, 1, 1, 3, 2.5, 2.5, 1, 1, 2], direction: .left) else {return}
        let actionSequence6 = SKAction.repeatForever(SKAction.sequence(path6))
        ghost6.wanderComponent?.wander(path: actionSequence6)
        
    }
    
    
    func addEventTriggers(){
        let eventTriggerOne = EventTriggerEntity(position: CGPoint(x: 0, y: -870), size: CGSize(width: 150, height: 1), action: SKAction.run { [self] in
            
            if boss.count < 1 {
                let bossGhost = BossEntity(entityManager: entityManager!)
                boss.append(bossGhost)
                entityManager?.add(entity: bossGhost)
                
                let ghostCherry = GhostCherryEntity(position:  CGPoint(x: -880, y: -80), entityManager: entityManager!)
                entityManager?.add(entity: ghostCherry)
                audioPlayerOne.stopLevelOneSong()
                audioPlayerTwo.playLevelTwoSong()
                songOneIsPlaying = true
                
                
                let messageOne = SKAction.sequence([
                    
                    SKAction.run {
                        self.textBox.textUpdate(text: "beware the Boss.")
                    },
                    
                    SKAction.run {
                        self.textBox.isHidden = false
                    },
                    
                    SKAction.wait(forDuration: 1.5),
                    
                    SKAction.run {
                        self.textBox.isHidden = true
                    }
                ])
                
                let messageTwo = SKAction.sequence([
                    
                    SKAction.run {
                        self.textBox.textUpdate(text: "hint: there is a cherry somewhere that can help.")
                    },
                    
                    SKAction.run {
                        self.textBox.isHidden = false
                    },
                    
                    SKAction.wait(forDuration: 1.5),
                    
                    SKAction.run {
                        self.textBox.isHidden = true
                    }
                ])
                
                let sequence =  SKAction.sequence([messageOne, messageTwo])
                
                self.run(sequence)
                
            }
            
            
        }, entityManager: entityManager!)
        entityManager?.add(entity: eventTriggerOne)
    }
    
    
    
    func addCheckpoints(){
        let chestPoint = PointEntity(position: CGPoint(x: 240, y: 344), size: CGSize(width: 32, height: 48), entityManager: entityManager!, texture: SKTexture(imageNamed: "bau1"))
        chestPoint.identityComponent?.name(name: "key")
        chestPoint.actionComponent?.addAction(action: SKAction.run {
            let action: SKAction = chestPoint.pointActions(.chest)
            
            chestPoint.animationComponent?.play(action: action)
            
            let didAdd = self.playerEntity?.inventoryComponent?.items.contains(where: { item in item.name == "pickaxe"})
            
            if didAdd == false {
                let item = Item(name: "pickaxe")
                self.playerEntity?.inventoryComponent?.addItem(item: item)
                let message = SKAction.sequence([
                    
                    SKAction.run {
                        self.textBox.isHidden = false
                    },
                    
                    SKAction.run {
                        self.textBox.textUpdate(text: "you got a pickaxe!")
                    },
                    
                    SKAction.wait(forDuration: 1.5),
                    
                    SKAction.run {
                        self.textBox.isHidden = true
                    }
                    
                ])
                self.run(message)
            }
            
        })
        entityManager?.add(entity: chestPoint)
        
        let stonePoint = PointEntity(position: CGPoint(x: 980, y: -1223), size: CGSize(width: 120, height: 85), entityManager: entityManager!, texture: SKTexture(imageNamed: "pedraDesmoronando1"))
        stonePoint.identityComponent?.name(name: "pickaxe")
        stonePoint.actionComponent?.addAction(action: SKAction.run {
            let action: SKAction = stonePoint.pointActions(.stone)
            
            let animation = SKAction.run {
                stonePoint.animationComponent?.play(action: action)
            }
            
            let die = SKAction.run {
                stonePoint.demiseComponent?.die()
            }
            
            let wait = SKAction.wait(forDuration: 1.1)
            
            let sequence = SKAction.sequence([animation, wait, die])
            
            self.run(sequence)
            
            self.entityManager?.remove(entity: stonePoint)
            
        })
        entityManager?.add(entity: stonePoint)
    }
    
    func addCherries() {
        let cherryItem1 = CherryEntity(position: CGPoint(x: -685, y: -80), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem1)
        
        let cherryItem2 = CherryEntity(position: CGPoint(x: -670, y: -350), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem2)
        
        let cherryItem3 = CherryEntity(position: CGPoint(x: 700, y: -970), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem3)
        
        let cherryItem4 = CherryEntity(position: CGPoint(x: 700, y: -970), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem4)
        
        let cherryItem5 = CherryEntity(position: CGPoint(x: -320, y: -1240), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem5)
        
        let cherryItem6 = CherryEntity(position: CGPoint(x: -320, y: -1240), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem6)
        
        let cherryItem7 = CherryEntity(position: CGPoint(x: -820, y: -970), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem7)
    }
    
    public func printSystemFonts() {
        // Use this identifier to filter out the system fonts in the logs.
        let identifier: String = "[SYSTEM FONTS]"
        // Here's the functionality that prints all the system fonts.
        for family in UIFont.familyNames as [String] {
            debugPrint("\(identifier) FONT FAMILY :  \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                debugPrint("\(identifier) FONT NAME :  \(name)")
            }
        }
    }
}
