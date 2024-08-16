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
    
    var demiseComponent: DemiseComponent? {
        return component(ofType: DemiseComponent.self)
    }
    
    var animationComponent: AnimationComponent? {
        return component(ofType: AnimationComponent.self)
    }
    
    init(position: CGPoint, entityManager : SKEntityManager) {
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
//        self.addComponent(LifetimeComponent(lifetime: lifetime))
        
        let death = SKAction.sequence([
            .removeFromParent(),
            .run {
                [weak self] in
                guard let self else {return}
                entityManager.remove(entity: self)
            }
        ])
        
        self.addComponent(DemiseComponent(death: death))
        
        let animationComp = AnimationComponent()
        self.addComponent(animationComp)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func platformActions(_ animation: PlatformAnimation) -> SKAction{
        switch animation {
        case .breakable:
            let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "plataformaQuebravel%@.png", range: 1...5), timePerFrame: 0.1))
            return action
        }
        
    }
}

