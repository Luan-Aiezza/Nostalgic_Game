//
//  PlayerIdle.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 23/07/24.
//

import Foundation
import GameplayKit
import SpriteKit

class PlayerIdle : GKState {
    
    weak var playerEntity : PlayerEntity?

    init(playerEntity: PlayerEntity) {
        self.playerEntity = playerEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let action = playerEntity?.playerActions(.idle) else {return}
        playerEntity?.animationComponent?.play(action: action)
        playerEntity?.moveComponent?.change(direction: .none)
    }
    
}
