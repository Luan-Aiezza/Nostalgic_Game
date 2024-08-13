//
//  EventTriggerEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 13/08/24.
//

import Foundation
import Foundation
import Foundation
import SpriteKit
import GameplayKit

class EventTriggerEntity : GKEntity {
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    var actionComponent: ActionComponent? {
        return component(ofType: ActionComponent.self)
    }
    
    init(position : CGPoint, size : CGSize, action: SKAction) {
        super.init()
        
        let node = SKSpriteNode()
        node.position = position
        node.size = size
        self.addComponent(GKSKNodeComponent(node: node))
        
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.affectedByGravity = false
        body.friction = 0
        body.categoryBitMask = .trigger
//        body.contactTestBitMask = .player
        body.collisionBitMask = .none
        let physicsComp = PhysicsComponent(body: body)
        self.addComponent(physicsComp)
        
        let actionComp = ActionComponent(action: action)
        self.addComponent(actionComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node {
            node.removeAllActions()
            node.removeFromParent()
        }
    }
    
}


