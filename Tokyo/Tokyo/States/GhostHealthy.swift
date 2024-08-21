//
//  GhostHealthy.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 25/07/24.
//
import Foundation
import GameplayKit
import SpriteKit

class GhostHealthy : GKState {
    
    weak var ghostEnemy : GhostEntity?

    init(ghostEntity: GhostEntity) {
        self.ghostEnemy = ghostEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let spriteName = ghostEnemy?.spriteComponent?.returnSpriteName() else {return}
        guard let action = ghostEnemy?.ghostActions(.healthy, spriteName: spriteName) else {return}
        ghostEnemy?.animationComponent?.play(action: action)
    }
    
}

