//
//  RestartButton.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 30/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class RestartButton : SKNode {
    
    var sprite : SKSpriteNode
    var label : SKLabelNode
    var action : () -> Void
    
    init(sprite : SKSpriteNode, label : SKLabelNode, action : @escaping () -> Void) {
        self.sprite = sprite
        self.label = label
        self.action = action
        super.init()
        
        self.addChild(sprite)
        self.addChild(label)
        
        label.zPosition = 10
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        action()
    }
}
