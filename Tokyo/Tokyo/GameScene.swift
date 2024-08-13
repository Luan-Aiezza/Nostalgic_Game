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
    
    private let playerLight = SKLightNode()  // Light node to follow the player

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
        
        self.camera?.setScale(0.75)
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

        let boss = BossEntity(entityManager: entityManager!)
        entityManager?.add(entity: boss)
        
        // Definindo posição inicial do Boss
        if let bossNode = boss.spriteNode{
            bossNode.position = CGPoint(x: 0, y: 50) // Defina a posição inicial desejada
        }
        
        setupButtons()
        adjustButtonLayout()
        
        setupPlayerLight()  // Set up the light node
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
        captureInput(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerEntity?.stateComponent?.stateMachine.enter(PlayerIdle.self)
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
            self.camera?.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 75)
            playerLight.position = playerNode.position  // Make the light follow the player
        }
        
        self.lastUpdateTime = currentTime
    }
    
    public func captureInput(touches: Set<UITouch>) {
        guard let camera else { return }
        if let location = touches.first?.location(in: camera){
            if right_button.contains(location) {
                playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                playerEntity?.moveComponent?.change(direction: .right)
                guard let inventory = playerEntity?.inventoryComponent?.items else {return}
                
                if inventory.count == 0 {
                    print()
                }
            }
            
            if left_button.contains(location) {
                playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                playerEntity?.moveComponent?.change(direction: .left)
                
                guard let inventory = playerEntity?.inventoryComponent?.items else {return}
                
                if inventory.count == 0 {
                    print()
                }
            }
            if jump_button.contains(location) {
                playerEntity?.jump()
                guard let inventory = playerEntity?.inventoryComponent?.items else {return}
                
                if inventory.count == 0 {
                    print()
                }
                else {
                    for i in inventory {
                        print(i.name)
                    }
                }
            }
        }
    }
    
    func gameOver() {
        let transition = SKTransition.fade(withDuration: 1)
        let newScene = GameOverScene(size: CGSize(width: 1980, height: 1800))
        newScene.scaleMode = .aspectFill
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view?.presentScene(newScene, transition: transition)
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
}

