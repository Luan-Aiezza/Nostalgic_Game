//
//  ItemEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 01/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

class ItemEntity : GKEntity {
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    var identityComponent: IdentifierComponent? {
        return component(ofType: IdentifierComponent.self)
    }
    
    var demiseComponent: DemiseComponent? {
        return component(ofType: DemiseComponent.self)
    }
    
    init(position : CGPoint, size : CGSize, entityManager: SKEntityManager, sprite: String) {
        super.init()
        
        let node = SKSpriteNode(imageNamed: sprite)
        node.position = position
        node.size = size
        node.size = CGSize(width: 130, height: 150)
        node.setScale(0.5)
        self.addComponent(GKSKNodeComponent(node: node))
        
        

//        let size : CGSize = .init(width: 15 * 7, height: 20 * 7)
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.affectedByGravity = true
        body.mass = 0
        body.friction = 0
        body.restitution = 0
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.affectedByGravity = true
        body.categoryBitMask = .items
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
        self.addComponent(IdentifierComponent())
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
