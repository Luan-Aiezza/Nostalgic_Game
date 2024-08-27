import Foundation
import SpriteKit
import GameplayKit

class JumpComponent: GKComponent {
    var isJumping = false
    var jumpImpulse: CGFloat = 400.0
    var horizontalImpulse: CGFloat = 0.2
    var doubleJumpAvailable = true
    var onGround = false
    
    var rightButtonPressed = false
    var leftButtonPressed = false

    func jump(horizontalDirection: CGFloat) {
        guard let physicsBody = (entity as? PlayerEntity)?.physicsComponent?.body else { return }
        
        if onGround {
            isJumping = true
            onGround = false
            doubleJumpAvailable = true
            physicsBody.applyImpulse(CGVector(dx: horizontalImpulse * horizontalDirection, dy: jumpImpulse))
        } else if doubleJumpAvailable {
            // Pulo duplo
            isJumping = true
            doubleJumpAvailable = false
            physicsBody.applyImpulse(CGVector(dx: horizontalImpulse * horizontalDirection, dy: jumpImpulse))

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
            isJumping = false
            jumpImpulse = 400
            horizontalImpulse = 0.2
        }
        
        else if physicsBody.linearDamping == 25{
            onGround = true
            isJumping = false
            jumpImpulse = 400
            horizontalImpulse = 120
        }
    }
}
