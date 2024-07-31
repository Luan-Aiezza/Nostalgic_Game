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
    var enemies:[GhostEntity] = []
    public var stateMachine : GKStateMachine?
    public var stateMachineEnemy : GKStateMachine?
    private var lastUpdateTime : TimeInterval = 0
    weak var playerEntity: PlayerEntity?
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self

        self.size = CGSize(width: 1980, height: 1800)
        
        entityManager = SKEntityManager(scene: self)
        
        let playerEntity = PlayerEntity(entityManager: entityManager!, size: CGSize(width: 100, height: 100))
        entityManager?.add(entity: playerEntity)
        self.playerEntity = playerEntity
        playerEntity.stateComponent?.stateMachine.enter(PlayerIdle.self)
        
        entityManager = SKEntityManager(scene: self)
        //Adicionando Level02 (CÓDIGO LUAN)

//        let scenarioEntity = TilesEntity(named: "Level02.sks", entityManager: entityManager!)
//        entityManager?.add(entity: scenarioEntity)
        
//        let cameraNode = SKCameraNode()
//        self.addChild(cameraNode)
//        self.camera = cameraNode
//        cameraNode.setScale(2.5)
//        self.camera?.setScale(1)
        //FIM DO CODIGO
        
        
//        entityManager?.add(entity: playerEntity)
//        self.playerEntity = playerEntity
//        stateMachine = GKStateMachine(states: [PlayerIdle(playerEntity: playerEntity), PlayerRun(playerEntity: playerEntity)]) // ADICIONAR NO PLAYER (DEPOIS)
        
        let wanderGhostEntity1 = SKAction.repeatForever(.sequence([.move(to: CGPoint(x: 240, y: 0), duration: 1), .move(to: CGPoint(x: 240, y: -100), duration: 1), .move(to: CGPoint(x: 180, y: -100), duration: 1), .move(to: CGPoint(x: 180, y: 0), duration: 1) ]))
        let ghostEntity = GhostEntity(position: CGPoint(x: 180, y: 0), entityManager: entityManager!, path: wanderGhostEntity1)
        ghostEntity.stateComponent?.stateMachine.enter(GhostHealthy.self)
        ghostEntity.wanderComponent?.wander()
        
        entityManager?.add(entity: ghostEntity)
        enemies.append(ghostEntity)
        
        
        let cherryEntity = CherryEntity(position: CGPoint(x: -140, y: 0), entityManager: entityManager!)
        entityManager?.add(entity: cherryEntity)
        //controles (checar auto layout)
        right_button.position = CGPoint(x: -140, y: -80)
        right_button.size = CGSize(width: 80, height: 80)
        right_button.name = "right_button"
        right_button.isUserInteractionEnabled =  false
        self.addChild(right_button)
        
        left_button.position = CGPoint(x: -280, y: -80)
        left_button.size = CGSize(width: 80, height: 80)
        left_button.name = "left_button"
        left_button.isUserInteractionEnabled =  false
        self.addChild(left_button)
        
        let spike = SpikeEntity(position: CGPoint(x: -190, y: 0))
        entityManager?.add(entity: spike)

        
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
        self.lastUpdateTime = currentTime
    }
    
    public func captureInput(touches: Set<UITouch>) {
        let right_button = childNode(withName: "right_button")
        let left_button = childNode(withName: "left_button")
        
        
        if let location = touches.first?.location(in: self){
            if right_button!.contains(location) {
                playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                playerEntity?.moveComponent?.change(direction: .right)
            }
            
            if left_button!.contains(location) {
                playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                playerEntity?.moveComponent?.change(direction: .left)
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
