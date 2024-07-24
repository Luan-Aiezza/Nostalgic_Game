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
        playerEntity?.animationComponent?.playIdle()
        playerEntity?.moveComponent?.change(direction: .none)
    }
    
}
