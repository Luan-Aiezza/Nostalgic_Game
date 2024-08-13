//
//  TemporaryLifeTimeComponent.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 11/08/24.
//

import Foundation
import GameplayKit
import SpriteKit

public class LifetimeComponent: GKComponent {
    
    private var remainingLifetime: TimeInterval
    private var shouldStartCountdown: Bool = false
    private weak var entityManager: SKEntityManager?
    
    init(lifetime: TimeInterval, entityManager: SKEntityManager) {
        self.remainingLifetime = lifetime
        self.entityManager = entityManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startCountdown() {
        self.shouldStartCountdown = true
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if shouldStartCountdown {
            remainingLifetime -= seconds
            if remainingLifetime <= 0 {
                if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
                    node.removeFromParent()
                }
                if let entity = entity {
                    entityManager?.remove(entity: entity)
                }
            }
        }
    }
}
