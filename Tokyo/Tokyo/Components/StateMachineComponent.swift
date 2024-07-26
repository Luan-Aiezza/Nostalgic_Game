//
//  StateMachineComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 26/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class StateMachineComponent : GKComponent {
    
    
    var stateMachine : GKStateMachine
    var node: SKNode?
    
    init(stateMachine: GKStateMachine) {
        self.stateMachine  = stateMachine
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
}
