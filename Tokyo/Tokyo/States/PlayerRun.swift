//
//  PlayerRun.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 23/07/24.
//

import Foundation
import GameplayKit
import SpriteKit

class PlayerRun : GKState {
    
    weak var playerEntity : PlayerEntity?
    
    init(playerEntity: PlayerEntity) {
        self.playerEntity = playerEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let action = playerEntity?.playerActions(.run) else {return}
        playerEntity?.physicsComponent?.body.linearDamping = 0
        playerEntity?.animationComponent?.play(action: action)
    }
}
