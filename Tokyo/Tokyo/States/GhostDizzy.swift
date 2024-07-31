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
        guard let action = ghostEnemy?.ghostActions(.dizzy) else {return}
        ghostEnemy?.animationComponent?.play(action: action)
        ghostEnemy?.wanderComponent?.wander()

    }
    
}


