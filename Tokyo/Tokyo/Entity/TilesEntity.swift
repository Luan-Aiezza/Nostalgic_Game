//
//  TilesEntity.swift
//  Tokyo
//
//  Created by Luan Aiezza on 26/07/24.
//

import Foundation
import GameplayKit
import SpriteKit

class TilesEntity: GKEntity {
    
    init(named: String, entityManager: SKEntityManager){
        super.init()
        if let scenarioNode = SKReferenceNode(fileNamed: named){
            self.addComponent(GKSKNodeComponent(node: scenarioNode))
            
            let children = scenarioNode.children[0].children
            
            for child in children {
                if child.name == "wall" {
                    let child = child as? SKSpriteNode
                    child?.addPhysicsToWall(entityManager: entityManager)
                }
                
                else if child.name == "ground" {
                    let child = child as? SKSpriteNode
                    child?.addPhysicsToGround(entityManager: entityManager)
                }
                
                else if child.name == "deepEnd" {
                    let child = child as? SKSpriteNode
                    child?.addPhysicsTodeepEnd(entityManager: entityManager)
                }
                
                
            }
            
        }

    }
    
    required  init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
