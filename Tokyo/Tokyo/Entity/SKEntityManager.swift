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
        
        if let nodeComponent = entity.component(ofType: GKSKNodeComponent.self) {
                    nodeComponent.node.removeFromParent()
                }
    }
    
    func entity(for node: SKNode) -> GKEntity? {
            // Busca a entidade que contém o node fornecido
            return entities.first(where: { entity in
                if let nodeComponent = entity.component(ofType: GKSKNodeComponent.self) {
                    return nodeComponent.node == node
                }
                return false
            })
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
    
    func returnGhosts() -> [GhostEntity?] {
        let ghosts = getEntities(ofType: GhostEntity.self)
        
        return ghosts
    }
    
}
