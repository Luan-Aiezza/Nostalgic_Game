//
//  GameScene.swift
//  Tokyo
//
//  Created by Luan Aiezza on 17/07/24.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    
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
        
        self.camera?.setScale(1)
        //FIM DO CODIGO
        
        let playerEntity = PlayerEntity(entityManager: entityManager!)
        entityManager?.add(entity: playerEntity)
        self.playerEntity = playerEntity
        playerEntity.stateComponent?.stateMachine.enter(PlayerIdle.self)
        
        let itemEntity = ItemEntity(position: CGPoint(x: -80, y: -220), size: CGSize(width: 50, height: 50), entityManager: entityManager!, sprite: "cherry_item")
        itemEntity.identityComponent?.name(name: "key")
        entityManager?.add(entity: itemEntity)
        
        let point1 = PointEntity(position: CGPoint(x: 130, y: -220), size: CGSize(width: 50, height: 50), entityManager: entityManager!)
        point1.identityComponent?.name(name: "key")
        entityManager?.add(entity: point1)
        
        
        let itemEntity2 = ItemEntity(position: CGPoint(x: 80, y: -220), size: CGSize(width: 50, height: 50), entityManager: entityManager!, sprite: "cherry_item")
        itemEntity2.identityComponent?.name(name: "pickaxe")
        entityManager?.add(entity: itemEntity2)
        
        
        //controles (checar auto layout)
        right_button.position = CGPoint(x: -140, y: -180)
        right_button.size = CGSize(width: 80, height: 80)
        right_button.name = "right_button"
        right_button.isUserInteractionEnabled =  false
        self.addChild(right_button)
        
        left_button.position = CGPoint(x: -230, y: -180)
        left_button.size = CGSize(width: 80, height: 80)
        left_button.name = "left_button"
        left_button.isUserInteractionEnabled =  false
        self.addChild(left_button)
        
        jump_button.position = CGPoint(x: 50, y: -180)
        jump_button.size = CGSize(width: 80, height: 80)
        jump_button.name = "jump_button"
        jump_button.isUserInteractionEnabled = false
        self.addChild(jump_button)
        
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
            self.camera?.position = playerNode.position
        }
        
        self.lastUpdateTime = currentTime
    }
    
    public func captureInput(touches: Set<UITouch>) {
        let right_button = childNode(withName: "right_button")
        let left_button = childNode(withName: "left_button")
        
        
        if let location = touches.first?.location(in: self){
            if right_button!.contains(location) {
                playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                playerEntity?.moveComponent?.change(direction: .right)
                guard let inventory = playerEntity?.inventoryComponent?.items else {return}
                
                if inventory.count == 0 {
                    print("nao tem nada")
                }
            }
            
            if left_button!.contains(location) {
                playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                playerEntity?.moveComponent?.change(direction: .left)
                
                guard let inventory = playerEntity?.inventoryComponent?.items else {return}
                
                if inventory.count == 0 {
                    print("nao tem nada")
                }
            }
            if jump_button.contains(location) {
                playerEntity?.jump()
                guard let inventory = playerEntity?.inventoryComponent?.items else {return}
                
                if inventory.count == 0 {
                    print("nao tem nada")
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
