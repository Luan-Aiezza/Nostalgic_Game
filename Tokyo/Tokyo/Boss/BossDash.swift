import GameplayKit
import Foundation
import SpriteKit

class BossDash: GKState {
    unowned let bossEntity: BossEntity
    var dashCompleted = false

    init(bossEntity: BossEntity) {
        self.bossEntity = bossEntity
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass != BossDash.self
    }

    override func didEnter(from previousState: GKState?) {
        bossEntity.spriteNode?.run(bossEntity.playerActions(.dash))
        print("Entrou em daash")
        // Logica de dass
        if let playerNode = bossEntity.entityManager.playerEntity?.spriteNode {
            let duration = 1.0
            bossEntity.dash(to: playerNode.position, duration: duration)
            
            // Dash completado
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
