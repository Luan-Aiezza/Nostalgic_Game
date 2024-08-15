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
        isContactWithGhostCherry(entityA: entityA, entityB: entityB)
        isContactWithGhostCherry(entityA: entityB, entityB: entityA)
        isContactWithBoss(entityA: entityA, entityB: entityB)
        isContactWithBoss(entityA: entityB, entityB: entityA)
    
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        guard let entityA = contact.bodyA.node?.entity,
              let entityB = contact.bodyB.node?.entity else {return}
        isNotInContactWithWall(entityA: entityA, entityB: entityB)
        isNotInContactWithWall(entityA: entityB, entityB: entityA)
        isContactWithEventTrigger(entityA: entityA, entityB: entityB)
        isContactWithEventTrigger(entityA: entityB, entityB: entityA)
        
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
    
    private func isContactWithBoss(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is BossEntity {
            let ghost = entityB as! BossEntity
            let player = entityA as! PlayerEntity
            
            guard let isKillable = ghost.killableComponent?.returnIsKillable() else {return}
            
            if isKillable != true{
                
                let pauseGhost = SKAction.sequence([SKAction.run {
                    ghost.stateComponent?.stateMachine.enter(BossIdle.self)
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
                
            
                let action = ghost.bossActions(BossAnimation.death)
                ghost.animationComponent?.play(action: action)
                ghost.component(ofType: GKSKNodeComponent.self)?.node.removeAction(forKey: "moving")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.64) {
                    ghost.demiseComponent?.die()
                    self.boss.removeAll()
                }
            }
        }
    }
    
    
    private func isContactWithCherry(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is CherryEntity {
            let waitAction = SKAction.wait(forDuration: 10)
            let waitActionCherry = SKAction.wait(forDuration: 0.1)
            
            let player = entityA as! PlayerEntity
            let cherry = entityB as! CherryEntity
            
            let message = SKAction.sequence([
            
                SKAction.run {
                    self.textBox.isHidden = false
                },
                
                SKAction.run {
                    self.textBox.textUpdate(text: "you eaten cherry!")
                },
                
                SKAction.wait(forDuration: 1.5),
                
                SKAction.run {
                    self.textBox.isHidden = true
                }
            
            ])
            self.run(message)
            
            cherry.component(ofType: GKSKNodeComponent.self)?.node.alpha = 0
            
            let eatCherry = SKAction.run {
                player.animationComponent?.play(action: player.playerActions(.eat))
            }
            
            let eatenCherry = SKAction.run {
                cherry.demiseComponent?.die()
            }
            
            let group = SKAction.group([eatCherry, waitActionCherry])
            
            self.run(SKAction.sequence([group,eatenCherry]))
            
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
    
    private func isContactWithGhostCherry(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is GhostCherryEntity {
            let waitActionCherry = SKAction.wait(forDuration: 0.1)
            
            let player = entityA as! PlayerEntity
            let cherry = entityB as! GhostCherryEntity
            
            cherry.component(ofType: GKSKNodeComponent.self)?.node.alpha = 0
            
            let eatCherry = SKAction.run {
                player.animationComponent?.play(action: player.playerActions(.eat))
            }
            
            let eatenCherry = SKAction.run {
                cherry.demiseComponent?.die()
            }
            
            let group = SKAction.group([eatCherry, waitActionCherry])
            
            self.run(SKAction.sequence([group,eatenCherry]))
            
            for bossGhost in boss {
                bossGhost.killableComponent?.isCurretlyKillable()
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
                let message = SKAction.sequence([
                
                    SKAction.run {
                        self.textBox.isHidden = false
                    },
                    
                    SKAction.run {
                        self.textBox.textUpdate(text: "you got \(item.returnName())!")
                    },
                    
                    SKAction.wait(forDuration: 1.5),
                    
                    SKAction.run {
                        self.textBox.isHidden = true
                    }
                
                ])
                self.run(message)
            }
        }
    }
    
    private func isContactWithPoint(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is PointEntity {
            
            print("entrou em contato")
            
            let player = entityA as! PlayerEntity
            let point = entityB as! PointEntity
            guard let pointName = point.identityComponent?.returnName() else {return}
            guard let items = player.inventoryComponent?.items else {return}
            var doesPlayerHaveIt = false
            
            for i in items {
                if i.name == pointName {
                    //                    guard let action = point.actionComponent?.action else {return}
                    //                    run(action)
                    doesPlayerHaveIt = true
                    
                }
            }
//
//                if items.count != 0 && i.name != pointName {
//                    let message = SKAction.sequence([
//                    
//                        SKAction.run {
//                            self.textBox.isHidden = false
//                        },
//                        
//                        SKAction.run {
//                            self.textBox.textUpdate(text: "you can't open it.")
//                        },
//                        
//                        SKAction.wait(forDuration: 1.5),
//                        
//                        SKAction.run {
//                            self.textBox.isHidden = true
//                        }
//                    ])
//                    self.run(message)
//                }
//            }
                
                if doesPlayerHaveIt {
                    guard let action = point.actionComponent?.action else {return}
                    run(action)
                }else {
                            let message = SKAction.sequence([
                            SKAction.run {
                            self.textBox.isHidden = false},
                    
                                            SKAction.run {
                                                self.textBox.textUpdate(text: "you can't open it.")
                                            },
                    
                                            SKAction.wait(forDuration: 1.5),
                    
                                            SKAction.run {
                                                self.textBox.isHidden = true
                                            }
                                        ])
                                        self.run(message)
                }
            
            
            if items.count == 0 {
                let message = SKAction.sequence([
                
                    SKAction.run {
                        self.textBox.isHidden = false
                    },
                    
                    SKAction.run {
                        self.textBox.textUpdate(text: "you can't open it.")
                    },
                    
                    SKAction.wait(forDuration: 1.5),
                    
                    SKAction.run {
                        self.textBox.isHidden = true
                    }
                ])
                self.run(message)
            }
        }
    }
    
    private func isContactWithEventTrigger(entityA: GKEntity, entityB: GKEntity) {
        
        if entityA is PlayerEntity && entityB is EventTriggerEntity {
            let eventTrigger = entityB as! EventTriggerEntity
            
            guard let action = eventTrigger.actionComponent?.action else {return}
            
            run(action)
            
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
