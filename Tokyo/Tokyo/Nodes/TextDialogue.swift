//
//  TextDialogue.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 14/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

class TextDialogue : SKNode {
    
    var sprite : SKSpriteNode
    var label : SKLabelNode
    
    init(sprite : SKSpriteNode, label : SKLabelNode) {
        self.sprite = sprite
        self.label = label
        super.init()
        
        self.addChild(sprite)
        self.addChild(label)
        
        label.zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textUpdate(text : String){
        self.label.text = text
    }
}
