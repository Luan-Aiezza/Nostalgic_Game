//
//  SpriteComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 07/08/24.
//

import Foundation
import SpriteKit
import GameplayKit


class SpriteComponent : GKComponent {
    
    weak var  node : SKNode?
    var sprite : SKSpriteNode?
    var spriteName: String = ""
    
    init(sprite : SKSpriteNode, spriteName: String) {
        self.sprite = sprite
        self.spriteName = spriteName
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    func returnSprite() -> SKSpriteNode{
        return self.sprite!
    }
    
    func returnSpriteName() -> String{
        return self.spriteName
    }
}

