//
//  JumpComponent.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 30/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class JumpComponent: GKComponent {
    var isJumping = false
    var jumpImpulse: CGFloat = 500.0
    var doubleJumpAvailable = true
    var onGround = false

    func jump() {
        guard let physicsBody = (entity as? PlayerEntity)?.physicsComponent?.body else { return }
        
        if onGround {

            isJumping = true
            onGround = false
            doubleJumpAvailable = true
            physicsBody.applyImpulse(CGVector(dx: 0, dy: jumpImpulse))
        } else if doubleJumpAvailable {
            // Pulo duplo
            isJumping = true
            doubleJumpAvailable = false
            physicsBody.applyImpulse(CGVector(dx: 0, dy: jumpImpulse))
        }
    }
    
    func resetJump(){
        isJumping = false
        doubleJumpAvailable = false
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let physicsBody = (entity as? PlayerEntity)?.physicsComponent?.body else { return }
        
        if physicsBody.velocity.dy == 0 {
            isJumping = false
            onGround = true
        }
    }
}
