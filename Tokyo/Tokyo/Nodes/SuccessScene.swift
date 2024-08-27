
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
        label.position = CGPoint(x: 0, y:-25)
        addChild(label)
        
//        let player = SKSpriteNode(imageNamed: "andyDeath1")
//        player.zPosition = 101
//        let animation = SKAction.repeatForever(.animate(with: .init(withFormat: "andyDeath%@.png", range: 1...15), timePerFrame: 0.1))
//        
//        self.addChild(player)
        
//        player.run(animation)
    }
}


//import Foundation
//import SpriteKit
//import GameplayKit
//
//class SuccessScene : SKScene{
//    
//    override func sceneDidLoad() {
//        self.backgroundColor = .black
//        
//        let player = SKSpriteNode(imageNamed: "andyDeath1")
//        
//        let animation = SKAction.repeatForever(.animate(with: .init(withFormat: "andyDeath%@.png", range: 1...15), timePerFrame: 0.1))
//        
//        addChild(player)
//        
//        player.run(animation)
//    }
//    
//    func gameOn() {
//        let transition = SKTransition.fade(withDuration: 1)
//        let newScene = GameScene(size: CGSize(width: 1980, height: 1800))
//        newScene.scaleMode = .aspectFill
//        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        self.view?.presentScene(newScene, transition: transition)
//    }
//}
//
//
//
//import SpriteKit
//
//class PausePopUp: SKNode {
//    var backgroud: SKSpriteNode?
//    var startButton: SKSpriteNode?
//    var playButton: SKSpriteNode?
//    var restartButton: SKSpriteNode?
//    
//    override init() {
//        super.init()
//        setupPopUp()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupPopUp() {
//        backgroud = SKSpriteNode(imageNamed: "backgroundPaused")
//        backgroud?.zPosition = 5
//        backgroud?.position = CGPoint(x: 0, y: 0)
//        backgroud?.setScale(1.5)
//        guard let backgroud = backgroud else { return }
//        addChild(backgroud)
//        
//        let backgrounWidth = backgroud.size.width
//        
//        startButton = SKSpriteNode(imageNamed: "inicio")
//        startButton?.zPosition = 6
//        startButton?.position = CGPoint(x:  -(backgrounWidth/3) , y: 0)
//        startButton?.setScale(1.5)
//        startButton?.name = "startButton"
//        guard let startButton = startButton else {return}
//        addChild(startButton)
//        
//        playButton = SKSpriteNode(imageNamed: "play")
//        playButton?.zPosition = 6
//        playButton?.position = CGPoint(x: 0, y: 0)
//        playButton?.setScale(1.5)
//        playButton?.name = "playButton"
//        guard let playButton = playButton else {return}
//        addChild(playButton)
//        
//        restartButton = SKSpriteNode(imageNamed: "reiniciar")
//        restartButton?.zPosition = 6
//        restartButton?.position = CGPoint(x: backgrounWidth/3, y:0)
//        restartButton?.setScale(1.5)
//        restartButton?.name = "restartButton"
//        guard let restartButton = restartButton else {return}
//        addChild(restartButton)
//        
//        
//        
//    }
//    func show(in scene: SKScene){
////        position = CGPoint(x: 0, y: -150)
//        scene.camera?.addChild(self)
//    }
//    func hide(){
//        removeFromParent()
//    }
//}
