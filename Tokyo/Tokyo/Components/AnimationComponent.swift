//
//  AnimationComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 23/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    
//    var action: SKAction
    var node: SKNode?
    
    
    override init() {
//        self.action = action
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    public func play(action : SKAction){
        node?.run(action)
    }
}
