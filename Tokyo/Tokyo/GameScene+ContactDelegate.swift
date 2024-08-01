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
        isContactWithItem(entityA: entityA, entityB: entityB)
        isContactWithItem(entityA: entityB, entityB: entityA)
        isContactWithPoint(entityA: entityA, entityB: entityB)
        isContactWithPoint(entityA: entityB, entityB: entityA)
    }
    
    private func isContactWithEnemy(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is GhostEntity {
            let ghost = entityB as! GhostEntity
            if ghost.stateComponent?.stateMachine.currentState is GhostHealthy{
            entityA.component(ofType: DemiseComponent.self)?.die()
            gameOver()
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
        
        let waitAction = SKAction.wait(forDuration: 1)
        
        if entityA is PlayerEntity && entityB is CherryEntity {
            
            entityB.component(ofType: DemiseComponent.self)?.die()
            
            for ghost in enemies{
                
                let dizzyGhost = SKAction.run {
                    ghost.stateComponent?.stateMachine.enter(GhostDizzy.self)
                }
                
                let healthyGhost = SKAction.run {
                    ghost.stateComponent?.stateMachine.enter(GhostHealthy.self)
                }
                let sequence = SKAction.sequence([dizzyGhost, waitAction, healthyGhost])
                
                run(sequence)
            }
        }
    }
    
        private func isContactWithItem(entityA: GKEntity, entityB: GKEntity) {
    
            if entityA is PlayerEntity && entityB is ItemEntity {
                
                
                let keyItem = entityB as! ItemEntity
                
                keyItem.demiseComponent?.die()
    
                let name = keyItem.identityComponent?.returnName()
                
                let didAdd = playerEntity?.inventoryComponent?.items.contains(where: { item in item.name == name})
                
                if didAdd == false {
                    let item = Item(name: name!)
                    playerEntity?.inventoryComponent?.addItem(item: item)
                }
            }
        }
    
    private func isContactWithPoint(entityA: GKEntity, entityB: GKEntity) {

        if entityA is PlayerEntity && entityB is PointEntity {
            
            let player = entityA as! PlayerEntity
            let point = entityB as! PointEntity
            let pointName = point.identityComponent?.returnName()
            guard let items = player.inventoryComponent?.items else {return}
            
            for i in items {
                if i.name == pointName {
                    point.demiseComponent?.die()
                    print("alguma coisa acontece!")
                }
                else {
                    print("não tem o " + i.name)
                }
            }
        
            
        }
    }
}



