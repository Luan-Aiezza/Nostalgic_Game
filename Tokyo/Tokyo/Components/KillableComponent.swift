//
//  KillableComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 14/08/24.
//

import Foundation
import GameplayKit
import SpriteKit
class KillableComponent : GKComponent {
    
    var  node : SKNode?
    var isKillable : Bool?
    
    override init() {
        self.isKillable = false
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    func isCurretlyKillable() {
        self.isKillable = true
    }
    
    func returnIsKillable() -> Bool?{
        return isKillable
    }
}

