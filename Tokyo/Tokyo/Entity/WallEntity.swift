//
//  WallEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 09/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

class WallEntity: GKEntity{
    
    init(size: CGSize, position: CGPoint){
        super.init()
        
        let node = SKSpriteNode(color: .red, size: size)//tirar o azul depois
        node.position = position
        self.addComponent(GKSKNodeComponent(node: node))
        
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.affectedByGravity = false
        self.addComponent(PhysicsComponent(body: body))
    }
    
    init(node: SKNode){
        super.init()
        
        self.addComponent(GKSKNodeComponent(node: node))
        let body = SKPhysicsBody(rectangleOf: node.calculateAccumulatedFrame().size)
        body.isDynamic = false
        body.pinned = true
        body.affectedByGravity = false
        self.addComponent(PhysicsComponent(body: body))
        
        let debug = SKShapeNode(rectOf: node.calculateAccumulatedFrame().size)
        debug.fillColor = .systemPink
        node.addChild(debug)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
