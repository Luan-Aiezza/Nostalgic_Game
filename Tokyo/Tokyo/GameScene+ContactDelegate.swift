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
        isContactWithWall(entityA: entityA, entityB: entityB)
        isContactWithWall(entityA: entityB, entityB: entityA)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        guard let entityA = contact.bodyA.node?.entity,
              let entityB = contact.bodyB.node?.entity else {return}
        isNotInContactWithWall(entityA: entityA, entityB: entityB)
        isNotInContactWithWall(entityA: entityB, entityB: entityA)
        
    }
    
    private func isContactWithEnemy(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is GhostEntity {
            let ghost = entityB as! GhostEntity
            let player = entityA as! PlayerEntity
            
            if ghost.stateComponent?.stateMachine.currentState is GhostHealthy{
                
                let pauseGhost = SKAction.sequence([SKAction.run {
                    ghost.moveComponent?.change(direction: .none)
                    ghost.component(ofType: GKSKNodeComponent.self)?.node.removeAction(forKey: "moving")
                }, .wait(forDuration: 0.3), .run {
                    ghost.component(ofType: GKSKNodeComponent.self)?.node.removeFromParent()
                }])
                
                let playerAction = SKAction.sequence([
                    .run {
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
                
                self.run(SKAction.sequence([pauseGhost, playerAction, gameOverScene]))
            }
            
            else {
                
                guard let spriteName = ghost.spriteComponent?.returnSpriteName() else {return}
                let action = ghost.ghostActions(GhostAnimation.death, spriteName: spriteName)
                
                ghost.moveComponent?.change(direction: .none)
                ghost.animationComponent?.play(action: action)
                ghost.component(ofType: GKSKNodeComponent.self)?.node.removeAction(forKey: "moving")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.64) {
                    ghost.demiseComponent?.die()
                    guard let index = self.enemies.firstIndex(of: ghost) else {return}
                    self.enemies.remove(at: index)
                }
            }
        }
    }
    
    
    private func isContactWithCherry(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is CherryEntity {
            let waitAction = SKAction.wait(forDuration: 10)
            let waitActionCherry = SKAction.wait(forDuration: 0.5)
            
            let player = entityA as! PlayerEntity
            let cherry = entityB as! CherryEntity

            let eatCherry = SKAction.run {
            player.animationComponent?.play(action: player.playerActions(.eat))
            }
            
            let eatenCherry = SKAction.run {
            cherry.demiseComponent?.die()
            }
            
            let group = SKAction.group([eatCherry, waitActionCherry ,eatenCherry])
            
            self.run(group)
            
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
    
    func isContactWithWall(entityA: GKEntity, entityB: GKEntity){
        
        if entityA is PlayerEntity && entityB is WallEntity {
            let player = entityA as? PlayerEntity
            
            if player?.physicsComponent?.body.velocity.dy != 0 {
                player?.stateComponent?.stateMachine.enter(PlayerWallSlide.self)
            }
            else {
                print("não deu para entrar em WallSlide pois a velocidade angular atual é de \(String(describing: player?.physicsComponent?.body.velocity.dy))")
            }
        }
    }
    
    func isNotInContactWithWall(entityA: GKEntity, entityB: GKEntity){
        
        if entityA is PlayerEntity && entityB is WallEntity {
            let player = entityA as? PlayerEntity
            
            if rightButtonPressed == false && leftButtonPressed == false{
                player?.stateComponent?.stateMachine.enter(PlayerIdle.self)
            }
            else {
                player?.stateComponent?.stateMachine.enter(PlayerRun.self)
            }
            
            player?.jumpComponent?.jumpImpulse = 500
            player?.jumpComponent?.jumpImpulse = 100
            
        }
    }
}
