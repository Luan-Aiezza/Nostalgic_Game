import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    var entityManager: SKEntityManager?
    var right_button = SKSpriteNode(imageNamed: "right")
    var left_button = SKSpriteNode(imageNamed: "left")
    var jump_button = SKSpriteNode(imageNamed: "jump")
    var enemies:[GhostEntity] = []
    public var stateMachine : GKStateMachine?
    public var stateMachineEnemy : GKStateMachine?
    private var lastUpdateTime : TimeInterval = 0
    weak var playerEntity: PlayerEntity?
    var rightButtonPressed = false
    var leftButtonPressed = false
    private let playerLight = SKLightNode()  // Light node to follow the player
    
    var pauseButton = SKSpriteNode(imageNamed: "pause")
    var pausePopUp: PausePopUp?
    
    
    
    override func sceneDidLoad() {
        
        self.physicsWorld.contactDelegate = self
        
        entityManager = SKEntityManager(scene: self)
        //Adicionando Level02 (CÓDIGO LUAN)
        
        initializeBackground()
        
        let scenarioEntity = TilesEntity(named: "Level02.sks", entityManager: entityManager!)
        entityManager?.add(entity: scenarioEntity)
        
        let cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        self.camera?.setScale(0.35)
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
        
        //        let boss = BossEntity(entityManager: entityManager!)
        //        entityManager?.add(entity: boss)
        
        // Definindo posição inicial do Boss
        //        if let bossNode = boss.spriteNode{
        //            bossNode.position = CGPoint(x: 0, y: 50) // Defina a posição inicial desejada
        //        }
        
        let keyItem = ItemEntity(position: CGPoint(x: 0, y: -580), size: CGSize(width: 100, height: 100), entityManager: entityManager!, sprite: "key")
        entityManager?.add(entity: keyItem)
        
        let cherryItem = CherryEntity(position: CGPoint(x: 160, y: -255), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem)
        
        setupButtons()
        adjustButtonLayout()
        ghostAdd()
        setupPlayerLight()  // Set up the light node
        setupPauseButton()
        
        let pausePopUp = PausePopUp()
        self.pausePopUp = pausePopUp
    }
    
    func setupPauseButton(){
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: 32, height: 32)
        pauseButton.position = CGPoint(x: 0, y: -150)
        pauseButton.zPosition = 10
        self.camera?.addChild(pauseButton)
    }
    // Function to set up the light node
    private func setupPlayerLight() {
        playerLight.categoryBitMask = 1  // Define a categoria da luz
        playerLight.lightColor = .white  // Cor da luz
        playerLight.ambientColor = .black // Cor do ambiente ao redor (escurecer)
        playerLight.falloff = 1  // Quão rápido a luz escurece
        playerLight.isEnabled = true
        
        self.addChild(playerLight)  // Adiciona a luz à cena
        
        
    }
    
    
    func setupButtons(){
        right_button.name = "right_button"
        self.camera?.addChild(right_button)
        
        left_button.name = "left_button"
        self.camera?.addChild(left_button)
        
        jump_button.name = "jump_button"
        self.camera?.addChild(jump_button)
        
    }
    
    func adjustButtonLayout() {
        guard let camera = self.camera else { return }
        let buttonSize = CGSize(width: 80, height: 80)
        
        right_button.size = buttonSize
        left_button.size = buttonSize
        jump_button.size = buttonSize
        
        let cameraFrame = camera.calculateAccumulatedFrame()
        
        left_button.position = CGPoint(x: cameraFrame.minX - 250, y: cameraFrame.minY - 90 )
        right_button.position = CGPoint(x: left_button.position.x + buttonSize.width + 20, y: left_button.position.y)
        
        jump_button.position = CGPoint(x: cameraFrame.maxX + 250, y:left_button.position.y)
    }
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        adjustButtonLayout()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            let location = touch.location(in: camera!)
            
            if pauseButton.contains(location) {
                isPaused.toggle()
                
                if (isPaused) {
                    self.pausePopUp?.show(in: self)
                } else {
                    self.pausePopUp?.hide()
                }
                
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
            playerLight.position = playerNode.position  // Make the light follow the player
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
        background.zPosition = -1 // Coloque atrás dos outros nodes
        background.alpha = 0.6
        background.setScale(3)
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
}

