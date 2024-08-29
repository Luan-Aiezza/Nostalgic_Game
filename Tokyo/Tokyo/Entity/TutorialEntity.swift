//
//  TutorialEntity.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 27/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

class TutorialEntity: GKEntity {
    init(texture: SKTexture) {
        super.init()
        
        texture.filteringMode =  .nearest
            
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.zPosition = 0
        spriteNode.setScale(0.7)
        
        let nodeComponent = GKSKNodeComponent(node: spriteNode)
        addComponent(nodeComponent)
        
    
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: spriteNode.size.width * 2, height: spriteNode.size.height * 2))
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = .tutorial
        physicsBody.contactTestBitMask = .player
        physicsBody.collisionBitMask = .none
        let physicsComponent = PhysicsComponent(body: physicsBody)
        addComponent(physicsComponent)
        
        spriteNode.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

