//
//  DeepEndEntity.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 16/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

class DeepEndEntity: GKEntity{
    
    init(size: CGSize, position: CGPoint){
        super.init()
        
        let node = SKSpriteNode(color: .red, size: size)//tirar o azul depois
        node.position = position
        self.addComponent(GKSKNodeComponent(node: node))
        
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.affectedByGravity = false
        body.categoryBitMask = .tile
        self.addComponent(PhysicsComponent(body: body))
        
//        // Configurando lightingBitMask e shadowBitMasks para interagir com a luz
//        node.lightingBitMask = 0       // A máscara que será afetada pela luz
//        node.shadowCastBitMask = 1     // Permite que o jogador lance sombras
//        node.shadowedBitMask = 1       // Permite que o jogador seja sombreado
//        node.color = .white            // Cor base do sprite
//        node.colorBlendFactor = 0.5
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

