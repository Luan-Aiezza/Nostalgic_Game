import SpriteKit
import Foundation
import GameplayKit

class BossPause: GKState {
    unowned let bossEntity: BossEntity

    init(bossEntity: BossEntity) {
        self.bossEntity = bossEntity
    }

    override func didEnter(from previousState: GKState?) {
        let wait = SKAction.wait(forDuration: 2.0)
        let action = SKAction.sequence([wait, SKAction.run {
            self.stateMachine?.enter(BossIdle.self)
        }])
        bossEntity.spriteNode?.run(action)
    }
}
