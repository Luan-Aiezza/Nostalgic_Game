//
//  Pause.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 14/08/24.
//

import SpriteKit

class PausePopUp: SKNode {
    var backgroud: SKSpriteNode?
    var startButton: SKSpriteNode?
    var playButton: SKSpriteNode?
    var restartButton: SKSpriteNode?
    
    override init() {
        super.init()
        setupPopUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPopUp() {
        
        
        backgroud = SKSpriteNode(imageNamed: "backgroundPaused")
        backgroud?.zPosition = 5
        backgroud?.position = CGPoint(x: 0, y: 0)
        backgroud?.setScale(1.5)
        guard let backgroud = backgroud else { return }
        addChild(backgroud)
        
        let backgrounWidth = backgroud.size.width
        let backgroundHeight = backgroud.size.height
        
        
        let label = SKLabelNode(text: "PAUSED")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: backgroundHeight - 10)
        addChild(label)
        
        startButton = SKSpriteNode(imageNamed: "inicio")
        startButton?.zPosition = 6
        startButton?.position = CGPoint(x:  -(backgrounWidth/3) , y: 0)
        startButton?.setScale(1.5)
        startButton?.name = "startButton"
        guard let startButton = startButton else {return}
        addChild(startButton)
        
        playButton = SKSpriteNode(imageNamed: "play")
        playButton?.zPosition = 6
        playButton?.position = CGPoint(x: 0, y: 0)
        playButton?.setScale(1.5)
        playButton?.name = "playButton"
        guard let playButton = playButton else {return}
        addChild(playButton)
        
        restartButton = SKSpriteNode(imageNamed: "reiniciar")
        restartButton?.zPosition = 6
        restartButton?.position = CGPoint(x: backgrounWidth/3, y:0)
        restartButton?.setScale(1.5)
        restartButton?.name = "restartButton"
        guard let restartButton = restartButton else {return}
        addChild(restartButton)
        
        
        
    }
    
    
    func show(in scene: SKScene){
        scene.camera?.addChild(self)
    }
    func hide(){
        removeFromParent()
    }
}
