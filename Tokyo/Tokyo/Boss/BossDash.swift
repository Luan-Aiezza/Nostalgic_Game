import GameplayKit
import Foundation
import SpriteKit

class BossDash: GKState {
    unowned let bossEntity: BossEntity
    var dashCompleted = false
    let dashSpeed: CGFloat = 300.0 // Velocidade fixa do dash

    init(bossEntity: BossEntity) {
        self.bossEntity = bossEntity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass != BossDash.self
    }

    override func didEnter(from previousState: GKState?) {
        bossEntity.spriteNode?.run(bossEntity.bossActions(.dash))
        
        if let playerNode = bossEntity.entityManager.playerEntity?.spriteNode {
            let distance = hypot(playerNode.position.x - bossEntity.spriteNode!.position.x,
                                 playerNode.position.y - bossEntity.spriteNode!.position.y)
            let duration = TimeInterval(distance / dashSpeed)
            
            bossEntity.dash(to: playerNode.position, duration: duration)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.dashCompleted = true
            }
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        if dashCompleted {
            stateMachine?.enter(BossPause.self)
        }
    }
}
