import SpriteKit
import Foundation
import GameplayKit

class BossIdle: GKState {
    unowned let bossEntity: BossEntity
    let timeToDash: TimeInterval = 1
    var timeAcumulated: TimeInterval = 0

    init(bossEntity: BossEntity) {
        self.bossEntity = bossEntity
    }

    override func didEnter(from previousState: GKState?) {
        bossEntity.spriteNode?.run(bossEntity.playerActions(.idle))
    }

    override func update(deltaTime seconds: TimeInterval) {
        timeAcumulated += seconds
        
        if timeAcumulated > timeToDash {
            timeAcumulated = 0
            bossEntity.stateComponent?.stateMachine.enter(BossDash.self)
        }
    }
}
