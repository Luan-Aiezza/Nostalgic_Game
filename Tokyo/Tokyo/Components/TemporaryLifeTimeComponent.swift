//
//  TemporaryLifeTimeComponent.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 11/08/24.
//

import Foundation
import GameplayKit
import SpriteKit

import Foundation
import GameplayKit
import SpriteKit

public class LifetimeComponent: GKComponent {
    
    private var remainingLifetime: TimeInterval
    private var physicsComponent: PhysicsComponent?
    private var itShouldFall: Bool = false
    
    init(lifetime: TimeInterval) {
        remainingLifetime = lifetime
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func shouldFall(itShouldFall: Bool) {
        self.itShouldFall = itShouldFall
        print(itShouldFall)
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        if physicsComponent == nil {
            physicsComponent = entity?.component(ofType: PhysicsComponent.self)
        }
        
        if itShouldFall {
            remainingLifetime -= seconds
            if remainingLifetime <= 0 {
                //let the block fall after the time ends
                if let physicsComponent = physicsComponent {
                    physicsComponent.body.isDynamic = true
                    physicsComponent.body.affectedByGravity = true
                    physicsComponent.body.collisionBitMask = .contactWithAllCategories()
                }
                // Reset itShouldFall to false after the block falls
                itShouldFall = false
            }
        }
    }
}
