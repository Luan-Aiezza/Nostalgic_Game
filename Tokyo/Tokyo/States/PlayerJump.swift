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
        playerEntity.moveComponent?.jump(horizontalDirection: 0)
        
        print("entrou em pulo")
    }

    override func update(deltaTime seconds: TimeInterval) {
        // Checar se o pulo terminou
        if playerEntity.moveComponent?.isJumping == false && playerEntity.physicsComponent?.body.velocity.dy == 0 {
            stateMachine?.enter(PlayerIdle.self)
        }
    }
}
