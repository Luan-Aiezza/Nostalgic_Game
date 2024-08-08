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
            let player = entityA as! PlayerEntity
            
            if ghost.stateComponent?.stateMachine.currentState is GhostHealthy{
                let playerAction = SKAction.sequence([
                    .run {
                        
                        for ghost in self.enemies {
                            ghost.component(ofType: GKSKNodeComponent.self)?.node.isPaused = true
                        }
                        player.stateComponent?.stateMachine.enter(PlayerDeath.self)
                    },
                    .wait(forDuration: 1.3),
                    .run {
                        player.demiseComponent?.die()
                    },
                    .wait(forDuration: 0.2),
                ])
                let gameOverScene = SKAction.run {
                    self.gameOver()
                }
                
                self.run(SKAction.sequence([playerAction, gameOverScene]))
            }
            
            else {
                guard let index = enemies.firstIndex(of: entityB as! GhostEntity) else {return}
                entityB.component(ofType: DemiseComponent.self)?.die()
                enemies.remove(at: index)
                entityB.component(ofType: StateMachineComponent.self)?.stateMachine.enter(GhostDeath.self)
            }
        }
    }
    
    private func isContactWithCherry(entityA: GKEntity, entityB: GKEntity) {
        
        let waitAction = SKAction.wait(forDuration: 10)
        
        if entityA is PlayerEntity && entityB is CherryEntity {
            
            entityB.component(ofType: DemiseComponent.self)?.die()
            
            
            for ghost in enemies{
                
                let ghostDizzy = SKAction.run {
                    ghost.stateComponent?.stateMachine.enter(GhostDizzy.self)
                }
                
                let ghostHealthy = SKAction.run {
                    ghost.stateComponent?.stateMachine.enter(GhostHealthy.self)
                }
                
                let sequence = SKAction.sequence([ghostDizzy, waitAction, ghostHealthy])
                
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
            guard let pointName = point.identityComponent?.returnName() else {return}
            guard let items = player.inventoryComponent?.items else {return}
            
            for i in items {
                if i.name == pointName {
                    point.demiseComponent?.die()
                    print("alguma coisa acontece!")
                }
                else {
                    print("não tem " + pointName)
                }
            }
            
            
        }
    }
    private func isInContactWithTile(entityA: GKEntity, entityB: GKEntity){
        
        if entityA is PlayerEntity && entityB is TilesEntity {
            entityA.component(ofType: JumpComponent.self)?.resetJump()
        }
    }
}
