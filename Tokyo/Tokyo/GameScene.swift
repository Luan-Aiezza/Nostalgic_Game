//
//  GameScene.swift
//  Tokyo
//
//  Created by Luan Aiezza on 17/07/24.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    
    //    let playerCategory:UInt32 = 0x1 >> 0
    //    let ghostCategory:UInt32 = 0x1 >> 1
    
    
    var entityManager: SKEntityManager?
    var right_button = SKSpriteNode(imageNamed: "botao_direito")
    var left_button = SKSpriteNode(imageNamed: "botao_esquerdo")
    var jump_button = SKSpriteNode(imageNamed: "botao_pulo")
    var enemies:[GhostEntity] = []
    public var stateMachine : GKStateMachine?
    public var stateMachineEnemy : GKStateMachine?
    private var lastUpdateTime : TimeInterval = 0
    weak var playerEntity: PlayerEntity?
    
    override func sceneDidLoad() {
        
        self.physicsWorld.contactDelegate = self
        
        entityManager = SKEntityManager(scene: self)
        //Adicionando Level02 (CÓDIGO LUAN)
        
        let scenarioEntity = TilesEntity(named: "Level02.sks", entityManager: entityManager!)
        entityManager?.add(entity: scenarioEntity)
        
        let cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        self.camera?.setScale(0.75)
        //FIM DO CODIGO
        
        let playerEntity = PlayerEntity(entityManager: entityManager!)
        entityManager?.add(entity: playerEntity)
        self.playerEntity = playerEntity
        playerEntity.stateComponent?.stateMachine.enter(PlayerIdle.self)
        
        let ghostEntity = GhostEntity(position: CGPoint(x: -80, y: -220), entityManager: entityManager!, spriteName: "redGhost")
        ghostEntity.stateComponent?.stateMachine.enter(GhostDizzy.self)
        entityManager?.add(entity: ghostEntity)
        enemies.append(ghostEntity)
        
        setupButtons()
        adjustButtonLayout()
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
}
