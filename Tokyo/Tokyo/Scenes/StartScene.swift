//
//  StartScene.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 13/08/24.
//

import Foundation
import SpriteKit

class StartScene: SKScene {
    
    var backgroud: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        backgroud = SKSpriteNode(imageNamed: "backgroundStartScene")
        backgroud?.zPosition = -2
        backgroud?.position = CGPoint(x: 0, y: 0)
        backgroud?.setScale(1)
        guard let backgroud = backgroud else { return }
        addChild(backgroud)
        
//        let backgrounWidth = backgroud.size.width
        
        let button = SKSpriteNode(imageNamed: "play")
        button.position = CGPoint(x: 250, y: -100)
        button.name = "startButton"
        button.texture?.filteringMode = .nearest
        button.setScale(2)
        
        
//        let label = SKLabelNode(text: "START")
//        label.fontName = "AvenirNext-Bold"
//        label.fontSize = 40
//        label.fontColor = .white
//        label.position = CGPoint(x: 0, y: -10)
//        
//        button.addChild(label)
        
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "startButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = SKScene(fileNamed: "GameScene")!
                self.view?.presentScene(gameScene, transition: transition)

            }
        }
    }
}
