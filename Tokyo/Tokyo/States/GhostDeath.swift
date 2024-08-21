//
//  GhostDeath.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 08/08/24.
//
import Foundation
import GameplayKit

class GhostDeath: GKState {
    
    weak var ghostEnemy : GhostEntity?

    init(ghostEntity: GhostEntity) {
        self.ghostEnemy = ghostEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let spriteName = ghostEnemy?.spriteComponent?.returnSpriteName() else {return}
        guard let action = ghostEnemy?.ghostActions(.death, spriteName: spriteName) else {return}
        
        ghostEnemy?.animationComponent?.play(action: action)
        
        print("entrou em GhostDeath")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
      return false
    }
    
}

