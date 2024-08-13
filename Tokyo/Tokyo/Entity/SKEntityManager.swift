//
//  SKEntityManager.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 23/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class SKEntityManager {
    
    
    // utiliza set para não repetir entities dentro da cena
    var entities = Set<GKEntity>()
    
    weak var scene: GameScene?
    
    
    //referencia a cena
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity){
        entities.insert(entity)
        
        if let node = entity.component(ofType: GKSKNodeComponent.self)?.node, node.parent == nil {
            scene?.addChild(node)
        }
    }
        
    func remove(entity: GKEntity){
        entities.remove(entity)
    }
    
    func getEntities<T: GKEntity>(ofType type: T.Type) -> [T] {
        return entities.compactMap { $0 as? T }
    }
    
    var playerEntity: PlayerEntity? {
        return getEntities(ofType: PlayerEntity.self).first
    }
    
    func returnBoss() -> BossEntity? {
        let boss = getEntities(ofType: BossEntity.self).first
        
        return boss
    }
    
}
