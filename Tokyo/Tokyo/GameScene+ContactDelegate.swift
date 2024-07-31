//
//  GameScene+ContactDelegate.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 25/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let entityA = contact.bodyA.node?.entity,
              let entityB = contact.bodyB.node?.entity else {return}
        
        isContactWithEnemy(entityA: entityA, entityB: entityB)
        isContactWithEnemy(entityA: entityB, entityB: entityA)
        isContactWithCherry(entityA: entityA, entityB: entityB)
        isContactWithCherry(entityA: entityB, entityB: entityA)
    }
    
    private func isContactWithEnemy(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is GhostEntity {
            let ghost = entityB as! GhostEntity
            if ghost.stateComponent?.stateMachine.currentState is GhostHealthy{
                print("player morreu")
                entityA.component(ofType: DemiseComponent.self)?.die()
            }
            else {
                print("ghost morreu")
                entityB.component(ofType: DemiseComponent.self)?.die()
                guard let index = enemies.firstIndex(of: ghost) else {return}
                enemies.remove(at: index)
            }
        }
    }
    
    
    private func isContactWithCherry(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is CherryEntity {
            
            entityB.component(ofType: DemiseComponent.self)?.die()
            
            for ghost in enemies{
                ghost.stateComponent?.stateMachine.enter(GhostDizzy.self)
            }
        }
    }
    
    
    private func isContactWithItem(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is ItemEntity {
            
            let name = entityB.component(ofType: IdentifierComponent.self)?.returnName()
            
            let item = Item(name: name!)
            
            entityB.component(ofType: DemiseComponent.self)?.die()
        
            playerEntity?.iventoryComponent?.addItem(item: item)
            
            print(playerEntity?.iventoryComponent?.items ?? "0")
        }
    }
}



