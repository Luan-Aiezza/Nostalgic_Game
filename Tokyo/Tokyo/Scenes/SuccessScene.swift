//
//  SuccessScene.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 21/08/24.
//

import Foundation
import SpriteKit
import GameplayKit

class SuccessScene : SKScene{
    
    override func sceneDidLoad() {
        self.backgroundColor = .black
        
        let player = SKSpriteNode(imageNamed: "andyDeath1")
        
        let animation = SKAction.repeatForever(.animate(with: .init(withFormat: "andyDeath%@.png", range: 1...15), timePerFrame: 0.1))
        
        addChild(player)
        
        player.run(animation)
    }
    
    func gameOn() {
        let transition = SKTransition.fade(withDuration: 1)
        let newScene = GameScene(size: CGSize(width: 1980, height: 1800))
        newScene.scaleMode = .aspectFill
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view?.presentScene(newScene, transition: transition)
    }
}

