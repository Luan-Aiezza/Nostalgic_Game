//
//  GhostDizzy.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 25/07/24.
//

import Foundation
import GameplayKit
import SpriteKit

class GhostDizzy : GKState {
    
    weak var ghostEnemy : GhostEntity?

    init(ghostEntity: GhostEntity) {
        self.ghostEnemy = ghostEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        ghostEnemy?.animationComponent?.playDizzy()
    }
    
}


