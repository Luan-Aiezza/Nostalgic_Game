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
        
        guard let entityA = contact.bodyA.node?.entity,
              let entityB = contact.bodyB.node?.entity else { return }
        
        
        handleContactBetweenPlayerAndPlatform(entityA: entityA, entityB: entityB)
        handleContactBetweenPlayerAndPlatform(entityA: entityB, entityB: entityA)
        
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        // Organiza os bodies para que o primeiro seja sempre o de menor categoria
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Verifica se o contato é entre o jogador e o bloco temporário
        if firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == .player {
            // Encontra a entidade do bloco a partir do corpo físico
            if let blockNode = firstBody.node,
               let blockEntity = entityManager?.entity(for: blockNode) as? TemporaryBlockEntity {
                
                // Remove o bloco da cena
                blockNode.removeFromParent()
                entityManager?.remove(entity: blockEntity)
            }
        }
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
    
    private func handleContactBetweenPlayerAndPlatform(entityA: GKEntity, entityB: GKEntity) {
        if let player = entityA as? PlayerEntity, let platform = entityB as? TemporaryBlockEntity {
            // Inicia a contagem regressiva para desaparecer
            platform.temporaryBlockComponent?.startCountdown()
        }
    }

    
    
    
}
