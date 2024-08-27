//
//  MessageComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 27/08/24.
//

import Foundation
import SpriteKit
import GameplayKit


class MessageComponent : GKComponent {
    
    var  node : SKNode?
    var message : String
    
    init(message : String) {
        self.message = message
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
}


