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
    
    var scene: GameScene
    
    
    //referencia a cena
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity){
        entities.insert(entity)
        
        if let node = entity.component(ofType: GKSKNodeComponent.self)?.node{
            scene.addChild(node)
        }
    }
        
    func remove(entity: GKEntity){
        entities.remove(entity)
    }
    
}
