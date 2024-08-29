
//SuccessScene.swift
//Tokyo
//Created by Jessica Rodrigues on 22/08/24.


import Foundation
import SpriteKit
import GameplayKit

class SuccessScene : SKNode {
    
    var background : SKShapeNode?
    var player : SKSpriteNode?
    var size : CGSize
    
    init(size : CGSize) {
        self.size = size
        super.init()
        setUpAnimation(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpAnimation(size : CGSize){
        let action = SKAction.fadeIn(withDuration: 2)
        background = SKShapeNode(rectOf: size)
        background?.fillColor = .black
        background?.zPosition = 10
        guard let backgroundScene = background else {return}
        addChild(backgroundScene)
        backgroundScene.run(action)
        
        let label = SKLabelNode(text: "YOU DID IT!")
        label.fontName = "TheFirstPalmPDAFont"
        label.fontSize = 24
        label.color = .white
        label.zPosition = 10
        label.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        label.position = CGPoint(x: 0, y: 70)
        addChild(label)
        
        let player = SKSpriteNode(imageNamed: "andyFeliz1")
        player.zPosition = 101
        player.position = CGPoint(x: 0, y: 0)
        let animation = SKAction.repeatForever(.animate(with: .init(withFormat: "andyFeliz%@.png", range: 1...2), timePerFrame: 0.4))
        
        self.addChild(player)
        
        player.run(animation)
    }
}
