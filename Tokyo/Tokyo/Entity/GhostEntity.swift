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
    
    var wanderComponent: WanderComponent? {
        return component(ofType: WanderComponent.self)
    }

    
    
    public init(position : CGPoint, entityManager: SKEntityManager, path : SKAction) {
        
        super.init()
        
        let node = SKSpriteNode(imageNamed: "ghost1.png")
        node.position = position
        node.size = CGSize(width: 130, height: 150)
        node.setScale(0.5)
        self.addComponent(GKSKNodeComponent(node: node))
        

        let animationComp = AnimationComponent()
        self.addComponent(animationComp)
//
//        let animationComp = AnimationComponent(dizzyAction: .repeatForever(.animate(with: .init(withFormat: "dizzy_ghost.png", range: 1...1), timePerFrame: 0.1)), healthyAction: .repeatForever(.animate(with: .init(withFormat: "ghost1.png", range: 1...1), timePerFrame: 0.1)))
//        self.addComponent(animationComp)

        let size : CGSize = .init(width: 15 * 7, height: 20 * 7)
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = true
        body.affectedByGravity = false
        body.mass = 0
        body.friction = 1
        body.restitution = 1
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.affectedByGravity = false
        body.categoryBitMask = .ghost
        body.contactTestBitMask = .player
        let physicsComp = PhysicsComponent(body: body)
        self.addComponent(physicsComp)
        
        let death = SKAction.sequence([
            .fadeOut(withDuration: 0.1),
            .run {
                [weak self] in
                guard let self else {return}
                entityManager.remove(entity: self)
            }])
        
        self.addComponent(DemiseComponent(death: death))
        
        let stateMachine = GKStateMachine(states: [GhostDizzy(ghostEntity: self), GhostHealthy(ghostEntity: self)])
        let stateComp = StateMachineComponent(stateMachine: stateMachine)
        self.addComponent(stateComp)

        
        let wanderComp = WanderComponent(path: path)
        self.addComponent(wanderComp)
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node {
            node.removeFromParent()
        }
    }
    
    func ghostActions(_ animation: GhostAnimation) -> SKAction{
        switch animation {
        case .dizzy:
            let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "dizzy_ghost.png", range: 1...1), timePerFrame: 0.1))
    
            return action
            
        case .healthy:
            let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "ghost1.png", range: 1...1), timePerFrame: 0.1))
            
            return action
        }
    }
    
}

