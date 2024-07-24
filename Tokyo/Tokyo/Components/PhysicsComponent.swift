//
//  PhysicsComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 24/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class PhysicsComponent: GKComponent{
    
    var node:SKNode?
    var texture: SKTexture?
    
    init(texture: SKTexture) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
//        sprite.physicsBody = [SKPhysicsBody bodyWithTexture:sprite.texture size:sprite.texture.size];
        addPhysics()
    }
    
    func addPhysics(){
        node?.physicsBody?.mass = 1
        node?.physicsBody?.friction = 1
        node?.physicsBody?.isDynamic = true
//        node?.physicsBody?.affectedByGravity = true
//        node?.physicsBody.area = (node?.frame.height)! * node?.frame.width
        node?.physicsBody?.restitution = 1
        node?.physicsBody?.usesPreciseCollisionDetection = true
        node?.physicsBody?.allowsRotation = false
    }
    
    
}
