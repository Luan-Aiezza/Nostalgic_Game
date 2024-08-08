import Foundation
import SpriteKit
import GameplayKit

class SKEntityManager {
    
    var entities = Set<GKEntity>()
    var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity) {
        entities.insert(entity)
        
        if let node = entity.component(ofType: GKSKNodeComponent.self)?.node {
            scene.addChild(node)
        }
    }
        
    func remove(entity: GKEntity) {
        entities.remove(entity)
        
        if let node = entity.component(ofType: GKSKNodeComponent.self)?.node {
            node.removeFromParent()
        }
    }
    
    func getEntities<T: GKEntity>(ofType type: T.Type) -> [T] {
        return entities.compactMap { $0 as? T }
    }
    
    var playerEntity: PlayerEntity? {
        return getEntities(ofType: PlayerEntity.self).first
    }
}
