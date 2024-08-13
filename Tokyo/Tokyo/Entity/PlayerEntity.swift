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
    
    var inventoryComponent: InventoryComponent? {
        return component(ofType: InventoryComponent.self)
    }
    
    var demiseComponent: DemiseComponent? {
        return component(ofType: DemiseComponent.self)
    }
    
    var spriteNode: SKSpriteNode? {
        return component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    }
    
    
    
    init(entityManager : SKEntityManager) {
        super.init()
        let node = SKSpriteNode(imageNamed: "andyIdle1")
        node.anchorPoint = .init(x: 0.5, y: 0.5)
        node.setScale(0.75)
        node.texture?.filteringMode = .nearest
        self.addComponent(GKSKNodeComponent(node: node))
        
        
        
        let moveComp = MovementComponent(speed: 5)
        self.addComponent(moveComp)
    
        let body = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width - 10 , height: node.size.height - 5))
        body.isDynamic = true
        body.mass = 1
        body.friction = 1
        body.restitution = 0
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.affectedByGravity = true
        body.categoryBitMask = .player
        body.linearDamping = 0
        body.contactTestBitMask = .ghost
        let physicsComp = PhysicsComponent(body: body)
        self.addComponent(physicsComp)
        
        let animationComp = AnimationComponent()
        self.addComponent(animationComp)
    
        
        let death = SKAction.sequence([
            .run {
                [weak self] in
                guard let self else {return}
                self.stateComponent?.stateMachine.enter(PlayerDeath.self)
                entityManager.remove(entity: self)
                self.spriteNode?.removeAllActions()
                self.spriteNode?.removeFromParent()
            }])
        
        self.addComponent(DemiseComponent(death: death))
        
        let jumpComp = JumpComponent()
        self.addComponent(jumpComp)
        
        let inventoryComp = InventoryComponent()
        self.addComponent(inventoryComp)
        
        let stateMachine = GKStateMachine(states: [PlayerIdle(playerEntity: self), PlayerRun(playerEntity: self), PlayerJump(playerEntity: self), PlayerDeath(playerEntity: self), PlayerWallSlide(playerEntity: self)])
        
        let stateComp = StateMachineComponent(stateMachine: stateMachine)
        
        
        self.addComponent(stateComp)
        
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node {
            node.removeFromParent()
            node.removeAllActions()
        }
    }
    
    func jump() {
        stateComponent?.stateMachine.enter(PlayerJump.self)
    }
    
    func jump(horizontalDirection: CGFloat) {
        jumpComponent?.jump(horizontalDirection: horizontalDirection)
    }
    
    func playerActions(_ animation: PlayerAnimation) -> SKAction{
        switch animation {
        case .idle:
            let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "andyIdle%@.png", range: 1...3), timePerFrame: 0.2))
            return action
            
        case .run:
            let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "andyRun%@.png", range: 1...3), timePerFrame: 0.1))
            return action
            
            
        case .death:
            let action: SKAction = .animate(with: .init(withFormat: "andyDeath%@.png", range: 1...15), timePerFrame: 0.1)
            return action
            
        case .eat:
            let action: SKAction = .animate(with: .init(withFormat: "andyEatingCherry%@", range: 1...4), timePerFrame: 0.15)
            return action
            
        case .wallSlide:
            let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "andySlide%@.png", range: 1...3), timePerFrame: 0.1))
            return action
        }
        
    }
    
}
