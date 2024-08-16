//
//  TemporaryBlockEntity.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 11/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

import Foundation
import SpriteKit
import GameplayKit

public class TemporaryBlockEntity: GKEntity{
    
    public var temporaryBlockComponent: LifetimeComponent? {
        return self.component(ofType: LifetimeComponent.self)
    }
    
    init(position: CGPoint, lifetime: TimeInterval) {
        super.init()
        
        //
        let blockNode = SKSpriteNode(imageNamed: "plataformaQuebravel1")
        blockNode.position = position
        self.addComponent(GKSKNodeComponent(node: blockNode))
        
        let body = SKPhysicsBody(rectangleOf: blockNode.size)
        body.categoryBitMask = .tempMask
        body.isDynamic = false
        body.affectedByGravity = false
        body.collisionBitMask = .contactWithAllCategories()
        body.contactTestBitMask = .player
        self.addComponent(PhysicsComponent(body: body))
        self.addComponent(LifetimeComponent(lifetime: lifetime))
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

