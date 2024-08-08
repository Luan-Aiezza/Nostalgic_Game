//
//  PlayerDeath.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 05/08/24.
//

import Foundation
import GameplayKit

class PlayerDeath: GKState {
    
    weak var playerEntity : PlayerEntity?
    
    init(playerEntity: PlayerEntity) {
        self.playerEntity = playerEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let action = playerEntity?.playerActions(.death) else {return}
        
        playerEntity?.animationComponent?.play(action: action)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
      return false
    }
    
}

