//
//  PlayerJump.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 30/07/24.
//

import GameplayKit

class PlayerJump: GKState {
    let playerEntity: PlayerEntity

    init(playerEntity: PlayerEntity) {
        self.playerEntity = playerEntity
    }

    override func didEnter(from previousState: GKState?) {
        // Iniciar animação de pulo
//        playerEntity.animationComponent?.playJumpAnimation()
        playerEntity.jumpComponent?.jump(horizontalDirection: 0)
    }

    override func update(deltaTime seconds: TimeInterval) {
        // Checar se o pulo terminou
        if playerEntity.jumpComponent?.isJumping == false && playerEntity.physicsComponent?.body.velocity.dy == 0 {
            stateMachine?.enter(PlayerIdle.self)
        }
    }
}
