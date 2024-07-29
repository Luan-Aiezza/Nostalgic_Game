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
    
    var moveComponent: MovementComponent? {
        return component(ofType: MovementComponent.self)
    }
    
    var animationComponent: AnimationComponent? {
        return component(ofType: AnimationComponent.self)
    }
    
    init(size : CGSize) {
        super.init()
        let node = SKSpriteNode(imageNamed: "idle1.png")
        node.anchorPoint = .init(x: 0.46, y: 0.25)
        node.setScale(0.5)
        node.size = size
        self.addComponent(GKSKNodeComponent(node: node))
        
        let animationComp = AnimationComponent(idleAction: .repeatForever(.animate(with: .init(withFormat: "idle%@.png", range: 1...10), timePerFrame: 0.1)), runAction: .repeatForever(.animate(with: .init(withFormat: "run%@.png", range: 1...10), timePerFrame: 0.1)))
        self.addComponent(animationComp)
        
        let moveComp = MovementComponent(speed: 5)
        self.addComponent(moveComp)
        
        
        let size2 = CGSize(width: node.size.width/3, height: node.size.height/3)
        let body = SKPhysicsBody(rectangleOf: size2)
        body.isDynamic = true
        body.affectedByGravity = false
        body.mass = 0
        body.friction = 1
        body.restitution = 0
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.affectedByGravity = true
        let physicsComp = PhysicsComponent(body: body)
        self.addComponent(physicsComp)
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

