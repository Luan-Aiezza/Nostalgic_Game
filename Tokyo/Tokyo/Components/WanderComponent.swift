//
//  WanderComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 30/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class WanderComponent : GKComponent {
    
    var path : SKAction
    var node : SKNode?
    
    init(path : SKAction) {
        self.path = path
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    public func wander(){
        node?.run(path)
    }
    
    public func follow(playerPosition : CGPoint){
        let action : SKAction = .move(to: playerPosition, duration: 1)
        node?.run(action)
    }
}


