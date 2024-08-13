//
//  TemporaryBlockEntity.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 11/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

public class TemporaryBlockEntity: GKEntity{
    
    public var temporaryBlockComponent: LifetimeComponent? {
        return self.component(ofType: LifetimeComponent.self)
    }
    
    init(position: CGPoint, lifetime: TimeInterval, entityManager: SKEntityManager) {
        super.init()
        
        let blockNode = SKSpriteNode(color: .red, size: CGSize(width: 32, height: 10))
        blockNode.position = position
        self.addComponent(GKSKNodeComponent(node: blockNode))
        
        let body = SKPhysicsBody(rectangleOf: blockNode.size)
        body.categoryBitMask = 1
        body.contactTestBitMask = .player
        body.isDynamic = false
        body.affectedByGravity = false
        body.collisionBitMask = .contactWithAllCategories()
        self.addComponent(PhysicsComponent(body: body))
        
        self.addComponent(LifetimeComponent(lifetime: lifetime, entityManager: entityManager))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
