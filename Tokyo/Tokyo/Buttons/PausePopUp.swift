//
//  Pause.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 14/08/24.
//

import SpriteKit

class PausePopUp: SKNode {
    private var background: SKSpriteNode!
    private var resumeButton: SKLabelNode!
    
    override init() {
        super.init()
        setupPopUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPopUp()
    }
    
    private func setupPopUp() {
        // Background for the pop-up
        background = SKSpriteNode(color: .black, size: CGSize(width: 300, height: 150))
        background.alpha = 0.75
        background.zPosition = 10
        addChild(background)
        
        // Resume Button
        resumeButton = SKLabelNode(text: "Continue")
        resumeButton.zPosition = 12
        resumeButton.fontName = "Arial"
        resumeButton.fontSize = 24
        resumeButton.position = CGPoint(x: 0, y: 0)
        resumeButton.name = "resumeButton"
        addChild(resumeButton)
    }
    
    func show(in scene: SKScene) {
        position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addChild(self)
    }
    
    func hide() {
        removeFromParent()
    }
}
