import SpriteKit
import Foundation
import GameplayKit

class BossPause: GKState {
    unowned let bossEntity: BossEntity

    init(bossEntity: BossEntity) {
        self.bossEntity = bossEntity
    }

    override func didEnter(from previousState: GKState?) {
        // Implement pause logic here (e.g., wait for a few seconds)
        let wait = SKAction.wait(forDuration: 2.0)
        let action = SKAction.sequence([wait, SKAction.run {
            self.stateMachine?.enter(BossIdle.self)
        }])
        bossEntity.spriteNode?.run(action)
    }
}
