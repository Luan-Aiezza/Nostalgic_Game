//
//  CherryEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 25/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class CherryEntity : GKEntity {
    
    var body: SKPhysicsBody?
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    var stateComponent: StateMachineComponent? {
        return component(ofType: StateMachineComponent.self)
    }
    
    var demiseComponent: DemiseComponent? {
        return component(ofType: DemiseComponent.self)
    }
    
    init(position : CGPoint, entityManager: SKEntityManager) {
        super.init()
        
        let node = SKSpriteNode(imageNamed: "cherry")
        node.texture?.filteringMode = .nearest
        node.position = position
        node.size = CGSize(width: 50, height: 50)
        node.setScale(0.5)
        self.addComponent(GKSKNodeComponent(node: node))
        

        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        body.isDynamic = false
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
//            .wait(forDuration: 0.2),
//            .fadeOut(withDuration: 0.2),
            .removeFromParent(),
            .run {
                [weak self] in
                guard let self else {return}
                entityManager.remove(entity: self)
            }
        ])
        
        self.addComponent(DemiseComponent(death: death))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node {
            node.removeFromParent()
        }
    }
    
}
