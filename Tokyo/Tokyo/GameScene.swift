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
    public var stateMachine : GKStateMachine?
    private var lastUpdateTime : TimeInterval = 0
    weak var playerEntity: PlayerEntity?
    
    override func sceneDidLoad() {
        entityManager = SKEntityManager(scene: self)
        
        let playerEntity = PlayerEntity()
        entityManager?.add(entity: playerEntity)
        self.playerEntity = playerEntity
        stateMachine = GKStateMachine(states: [PlayerIdle(playerEntity: playerEntity), PlayerRun(playerEntity: playerEntity)])
        
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
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        captureInput(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stateMachine?.enter(PlayerIdle.self)
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
                stateMachine?.enter(PlayerRun.self)
                playerEntity?.moveComponent?.change(direction: .right)
            }
            
            if left_button!.contains(location) {
                stateMachine?.enter(PlayerRun.self)
                playerEntity?.moveComponent?.change(direction: .left)
            }
        }
    }
    
    //CODIGO LUAN AIEZZA ---------------------------------------
    var entities: [GKEntity] = []
        var renderSystem: RenderSystem!
        
        override func didMove(to view: SKView) {
            super.didMove(to: view)
            
            // Inicialize o sistema de renderização
            renderSystem = RenderSystem(componentClass: GKComponent.self)
            
            // Crie o sprite da fase 1
            let spriteNode = SKSpriteNode(imageNamed: "Tilemap01")
            
            // Crie um corpo físico para o sprite
            let physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
            physicsBody.affectedByGravity = false
            
            // Crie a entidade e adicione os componentes
            let entity = GKEntity()
            entity.addComponent(PositionComponent(position: CGPoint(x: 0, y: -150)))
            entity.addComponent(SpriteComponent(spriteNode: spriteNode))
            entity.addComponent(ScaleComponent(scale: 1.5)) // Adiciona o componente de escala
            entity.addComponent(FilteringModeComponent(filteringMode: .nearest)) // Adiciona o componente de FilteringMode
            entity.addComponent(ColliderComponent(physicsBody: physicsBody)) // Adiciona o componente de Collider
            
            // Adicione a entidade à lista de entidades
            entities.append(entity)
            
            // Adicione os componentes ao sistema de renderização
            renderSystem.addComponent(foundIn: entity)
            
            // Renderize as entidades
            renderSystem.render(entities: entities, in: self)
        }
}
