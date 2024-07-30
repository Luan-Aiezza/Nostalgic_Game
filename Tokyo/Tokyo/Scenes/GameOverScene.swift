//
//  GameOverScene.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 30/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class GameOverScene : SKScene{
    
    override func sceneDidLoad() {
        self.backgroundColor = .black
        
        let button = RestartButton(sprite: .init(color: .blue, size:  CGSize(width: 100, height: 100)), label: SKLabelNode(text: "restart")) {
            self.gameOn()
        }
        
        self.addChild(button)
    }
    
    func gameOn() {
        let transition = SKTransition.fade(withDuration: 1)
        let newScene = GameScene(size: CGSize(width: 1980, height: 1800))
        newScene.scaleMode = .aspectFill
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view?.presentScene(newScene, transition: transition)
    }
}
