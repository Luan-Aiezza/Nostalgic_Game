//
//  GhostEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 25/07/24.
//



import Foundation
import SpriteKit
import GameplayKit

class GhostEntity: GKEntity {
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    var animationComponent: AnimationComponent? {
        return component(ofType: AnimationComponent.self)
    }
    
    var stateComponent: StateMachineComponent? {
        return component(ofType: StateMachineComponent.self)
    }
    
    var demiseComponent: DemiseComponent? {
        return component(ofType: DemiseComponent.self)
    }
    
    var spriteComponent: SpriteComponent? {
        return component(ofType: SpriteComponent.self)
    }
    
    var wanderComponent: WanderComponent? {
        return component(ofType: WanderComponent.self)
    }
    
    var moveComponent: MovementComponent? {
        return component(ofType: MovementComponent.self)
    }
    
    
    public init(position : CGPoint, entityManager: SKEntityManager, spriteName : String) {
        
        super.init()
        
        let spriteComp = SpriteComponent(sprite: SKSpriteNode(imageNamed: spriteName), spriteName: spriteName)
        self.addComponent(spriteComp)
        
        
        let node = spriteComp.returnSprite()
        node.position = position
        node.size = CGSize(width: 60, height: 60)
        node.setScale(0.5)
        self.addComponent(GKSKNodeComponent(node: node))
        
        
        let animationComp = AnimationComponent()
        self.addComponent(animationComp)
        let body = SKPhysicsBody(texture: SKTexture(imageNamed: "blueGhost1"), size: node.size)
        body.isDynamic = false
        body.usesPreciseCollisionDetection = false
        body.categoryBitMask = .ghost
        body.contactTestBitMask = .player
        let physicsComp = PhysicsComponent(body: body)
        self.addComponent(physicsComp)
        
        let death = SKAction.sequence([
            .removeFromParent(),
            .run {
                [weak self] in
                guard let self else {return}
                entityManager.remove(entity: self)
            }
        ])
        
        self.addComponent(DemiseComponent(death: death))
        
        let stateMachine = GKStateMachine(states: [GhostHealthy(ghostEntity: self), GhostDizzy(ghostEntity: self), GhostDeath(ghostEntity: self)])
        let stateComp = StateMachineComponent(stateMachine: stateMachine)
        self.addComponent(stateComp)
        
        
        let wanderComponent = WanderComponent()
        self.addComponent(wanderComponent)
        
        let moveComp = MovementComponent(speed: 5)
        self.addComponent(moveComp)
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node {
            node.removeFromParent()
        }
    }
    
    func ghostActions(_ animation: GhostAnimation, spriteName: String) -> SKAction{
        switch animation {
        case .dizzy:
            let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "\(spriteName)%@", range: 3...4), timePerFrame: 0.2))
            return action
            
        case .healthy:
            let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "\(spriteName)%@", range: 1...2), timePerFrame: 0.2))
            return action
        
        case .death:
            let action: SKAction = .animate(with: .init(withFormat: "\(spriteName)%@", range: 5...12), timePerFrame: 0.08)
            return action
        }
        
    }
}


