//
//  AnimationComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 23/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    
    var idleAction: SKAction
    var runAction: SKAction
    var dizzyAction: SKAction
    var healthyAction : SKAction
    var node: SKNode?
    
    
    init(idleAction: SKAction, runAction: SKAction) {
        self.idleAction = idleAction
        self.runAction = runAction
        self.dizzyAction = runAction
        self.healthyAction = runAction
        super.init()
    }
    
    init(dizzyAction: SKAction, healthyAction: SKAction) {
        self.idleAction = healthyAction
        self.runAction = dizzyAction
        self.dizzyAction = dizzyAction
        self.healthyAction = healthyAction
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
        playIdle()
    }
    
    public func playIdle(){
        node?.run(idleAction)
    }
    
    public func playRun(){
        node?.run(runAction)
    }
    
    public func playDizzy(){
        node?.run(dizzyAction)
    }
    
    public func playHealthy(){
        node?.run(healthyAction)
    }
}
