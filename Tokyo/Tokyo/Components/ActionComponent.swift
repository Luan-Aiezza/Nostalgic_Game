//
//  ActionComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 13/08/24.
//

import Foundation
import Foundation
import SpriteKit
import GameplayKit

class ActionComponent: GKComponent {
    
//    var action: SKAction
    weak var node: SKNode?
    var action : SKAction?
    
    
    init(action : SKAction) {
        self.action = action
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    public func runCode(scene: SKScene){
        scene.run(action!)
    }
}
