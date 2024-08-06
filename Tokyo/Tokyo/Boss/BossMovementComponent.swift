import SpriteKit
import Foundation
import GameplayKit

class BossMovementComponent: GKComponent {
    var speed: CGFloat
    
    init(speed: CGFloat) {
        self.speed = speed
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToPosition(_ position: CGPoint, duration: TimeInterval) {
        guard let spriteNode = entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode else {
            return
        }
        let moveAction = SKAction.move(to: position, duration: duration)
        spriteNode.run(moveAction)
    }
}
