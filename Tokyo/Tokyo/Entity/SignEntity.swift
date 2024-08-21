//
//  SignEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 15/08/24.
//

import Foundation
import GameplayKit
import SpriteKit
class SignEntity : GKEntity {
    
    var body: SKPhysicsBody?
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    
    init(position : CGPoint) {
        super.init()
        
        let node = SKSpriteNode(imageNamed: "spike_item.png")
        node.alpha = 0
        node.position = position
        node.size = CGSize(width: 100, height: 100)
        node.setScale(0.5)
        self.addComponent(GKSKNodeComponent(node: node))
        
        
        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        body.isDynamic = false
        body.affectedByGravity = false
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.affectedByGravity = false
        body.categoryBitMask = .boss
        body.collisionBitMask = .none
        body.contactTestBitMask = .player
        let physicsComp = PhysicsComponent(body: body)
        self.addComponent(physicsComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
