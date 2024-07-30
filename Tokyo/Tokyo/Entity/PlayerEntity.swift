//
//  PlayerEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 23/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
    var body: SKPhysicsBody?
    
    var moveComponent: MovementComponent? {
        return component(ofType: MovementComponent.self)
    }
    
    var animationComponent: AnimationComponent? {
        return component(ofType: AnimationComponent.self)
    }
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    var stateComponent: StateMachineComponent? {
        return component(ofType: StateMachineComponent.self)
    }
    var jumpComponent: JumpComponent? {
            return component(ofType: JumpComponent.self)
        }

    init(entityManager : SKEntityManager) {
        super.init()
        let node = SKSpriteNode(imageNamed: "idle1.png")
        node.anchorPoint = .init(x: 0.46, y: 0.25)
        node.setScale(0.5)
        self.addComponent(GKSKNodeComponent(node: node))
        
        let animationComp = AnimationComponent(idleAction: .repeatForever(.animate(with: .init(withFormat: "idle%@.png", range: 1...10), timePerFrame: 0.1)), runAction: .repeatForever(.animate(with: .init(withFormat: "run%@.png", range: 1...10), timePerFrame: 0.1)))
        self.addComponent(animationComp)
        
        let moveComp = MovementComponent(speed: 5)
        self.addComponent(moveComp)
        
        
        let size : CGSize = .init(width: 15 * 7, height: 20 * 7)
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = true
        body.mass = 1
        body.friction = 1
        body.restitution = 0
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.affectedByGravity = true
        body.categoryBitMask = .player
        body.contactTestBitMask = .ghost
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
        
        let jumpComp = JumpComponent()
        self.addComponent(jumpComp)
                
        let stateMachine = GKStateMachine(states: [PlayerIdle(playerEntity: self), PlayerRun(playerEntity: self), PlayerJump(playerEntity: self)])
        let stateComp = StateMachineComponent(stateMachine: stateMachine)
                
        
        self.addComponent(stateComp)
        
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node {
            node.removeFromParent()
        }
    }
    func jump() {
            stateComponent?.stateMachine.enter(PlayerJump.self)
        }
}

