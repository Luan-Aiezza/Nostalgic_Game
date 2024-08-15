//
//  PointEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 01/08/24.
//

import Foundation
import Foundation
import SpriteKit
import GameplayKit

class PointEntity : GKEntity {
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    var identityComponent: IdentifierComponent? {
        return component(ofType: IdentifierComponent.self)
    }
    
    var demiseComponent: DemiseComponent? {
        return component(ofType: DemiseComponent.self)
    }
    
    var actionComponent: ActionComponent? {
        return component(ofType: ActionComponent.self)
    }
    
    var animationComponent: AnimationComponent? {
        return component(ofType: AnimationComponent.self)
    }
    
    init(position : CGPoint, size : CGSize, entityManager: SKEntityManager, texture: SKTexture) {
        super.init()
        
        let node = SKSpriteNode(texture: texture)
        node.position = position
        node.size = node.texture?.size() ?? size
        node.setScale(0.5)
        self.addComponent(GKSKNodeComponent(node: node))
        
        let body = SKPhysicsBody(rectangleOf: size)
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
            .fadeOut(withDuration: 0.1),
            .run {
                [weak self] in
                guard let self else {return}
                entityManager.remove(entity: self)
            }])
        
        self.addComponent(DemiseComponent(death: death))
        self.addComponent(IdentifierComponent())
        
        let animationComp = AnimationComponent()
        self.addComponent(animationComp)
        
        let actionComp = ActionComponent()
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
    
    func pointActions(_ animation: PointAnimation) -> SKAction{
        switch animation {
        case .chest:
            let action: SKAction = .animate(with: .init(withFormat: "bau%@.png", range: 1...12), timePerFrame: 0.1)
            return action
            
        }
    }
}
