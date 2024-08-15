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
        isInContactWithTile(entityA: entityA, entityB: entityB)
        isInContactWithTile(entityA: entityB, entityB: entityA)
        isContactWithTemporaryBlock(entityA: entityA, entityB: entityB)
        isContactWithTemporaryBlock(entityA: entityB, entityB: entityA)
        
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
    
    private func isInContactWithTile(entityA: GKEntity, entityB: GKEntity){
        
        if entityA is PlayerEntity && entityB is TilesEntity {
            entityA.component(ofType: JumpComponent.self)?.resetJump()
        }
        
    }
    
    private func isContactWithTemporaryBlock(entityA: GKEntity, entityB: GKEntity) {
        // Verifica se entityA é o jogador e entityB é o bloco temporário
        if entityA is PlayerEntity, let block = entityB as? TemporaryBlockEntity {
            print("Entrou no contactdelegate")
            if let lifetimeComponent = entityB.component(ofType: LifetimeComponent.self) {
                lifetimeComponent.shouldFall(itShouldFall: true)
                
            }
            
        }
        
        // Verifica se entityB é o jogador e entityA é o bloco temporário
        if entityB is PlayerEntity, let block = entityA as? TemporaryBlockEntity {
            print("Entrou no contactdelegate")
            if let lifetimeComponent = entityA.component(ofType: LifetimeComponent.self) {
                lifetimeComponent.shouldFall(itShouldFall: true)
            }
        }
    }
    
    
    
    
}
