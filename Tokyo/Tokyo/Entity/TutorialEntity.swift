//
//  TutorialEntity.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 27/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

class TutorialEntity: GKEntity{
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
}
