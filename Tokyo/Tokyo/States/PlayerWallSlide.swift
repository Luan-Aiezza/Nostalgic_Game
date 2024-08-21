//
//  PlayerWallSlide.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 09/08/24.
//

import Foundation
import GameplayKit
import SpriteKit

class PlayerWallSlide : GKState {
    
    weak var playerEntity : PlayerEntity?
    
    init(playerEntity: PlayerEntity) {
        self.playerEntity = playerEntity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let action = playerEntity?.playerActions(.wallSlide) else {return}
        playerEntity?.animationComponent?.play(action: action)
        playerEntity?.physicsComponent?.body.linearDamping = 25
        
    }
    
    
}

