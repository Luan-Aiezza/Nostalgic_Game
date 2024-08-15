//
//  StartScene.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 13/08/24.
//

import Foundation
import SpriteKit

class StartScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.clear
        
        let button = SKSpriteNode(color: .blue, size: CGSize(width: 200, height: 100))
        button.position = CGPoint(x: 0, y: 0)
        button.name = "startButton"
        
        
        let label = SKLabelNode(text: "START")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: -10)
        
        button.addChild(label)
        
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "startButton" {
                print("Botão foi clicado!")
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = SKScene(fileNamed: "GameScene")!
                self.view?.presentScene(gameScene, transition: transition)
                print("Transição completa")
            }
        }
    }
}
