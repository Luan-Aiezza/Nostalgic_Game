//
//  GhostAgent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 30/07/24.
//

import Foundation
import GameplayKit
import SpriteKit

class GhostAgent : GKAgent2D {
    
    var player : GKAgent2D
    
    init(player : GKAgent2D) {
        self.player = player
        super.init()
        self.maxSpeed = 1000
        self.maxAcceleration = 3000
        self.rotation = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        delegate = entity?.component(ofType: GKSKNodeComponent.self)
    }
    
    func addBehavior(behavior : GKBehavior) {
        self.behavior = behavior
    }
    
}
