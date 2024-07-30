//
//  PlayerAgent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 30/07/24.
//

import Foundation
import GameplayKit
import SpriteKit

class PlayerAgent : GKAgent2D {
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        delegate = entity?.component(ofType: GKSKNodeComponent.self)
//        self.behavior = GKBehavior()
    }
    
}
