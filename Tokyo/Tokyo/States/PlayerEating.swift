//
//  PlayerEating.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 08/08/24.
//

import Foundation
import GameplayKit
import SpriteKit

class PlayerEating : GKState {
    
    weak var playerEntity : PlayerEntity?

    init(playerEntity: PlayerEntity) {
        self.playerEntity = playerEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let action = playerEntity?.playerActions(.eat) else {return}
        playerEntity?.animationComponent?.play(action: action)
        playerEntity?.physicsComponent?.body.linearDamping = 0
        playerEntity?.moveComponent?.change(direction: .none)
    }
    
}

