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
    
    weak var node:SKNode?
    var texture: SKTexture?
    var size: CGSize?
    var body: SKPhysicsBody
    
    
    init(body : SKPhysicsBody) {
        self.body = body
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
            node.physicsBody = self.body
        }
    }
}
