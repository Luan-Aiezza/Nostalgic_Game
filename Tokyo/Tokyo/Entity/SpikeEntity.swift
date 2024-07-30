//
//  SpikeEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 30/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class SpikeEntity : GKEntity {
    
    var body: SKPhysicsBody?
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    var stateComponent: StateMachineComponent? {
        return component(ofType: StateMachineComponent.self)
    }
    
    init(position : CGPoint) {
        super.init()
        
        let node = SKSpriteNode(imageNamed: "spike_item.png")
        node.position = position
        node.size = CGSize(width: 130, height: 150)
        node.setScale(0.5)
        self.addComponent(GKSKNodeComponent(node: node))
        
        

        let size : CGSize = .init(width: 15 * 7, height: 20 * 7)
        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        body.isDynamic = false
        body.affectedByGravity = false
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.affectedByGravity = false
        body.categoryBitMask = .spike
        body.contactTestBitMask = .player
        let physicsComp = PhysicsComponent(body: body)
        self.addComponent(physicsComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
