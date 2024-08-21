//
//  MenuScene.swift
//  Tokyo
//
//  Created by Cecília Guimarães on 14/08/24.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // Título do Jogo
        let titleLabel = SKLabelNode(text: "Menu Principal")
        titleLabel.fontSize = 45
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        addChild(titleLabel)
        
        // Botão de Iniciar Jogo
        let startButton = SKLabelNode(text: "Iniciar Jogo")
        startButton.name = "startButton"
        startButton.fontSize = 35
        startButton.fontColor = .white
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startButton)
        
        // Botão de Sair
        let exitButton = SKLabelNode(text: "Sair")
        exitButton.name = "exitButton"
        exitButton.fontSize = 35
        exitButton.fontColor = .white
        exitButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        addChild(exitButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "startButton" {
                startGame()
            } else if node.name == "exitButton" {
                exitGame()
            }
        }
    }
    
    func startGame() {
        // Trocar para a cena do jogo
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.doorsOpenVertical(withDuration: 1.0))
    }
    
    func exitGame() {
        // Encerrar o jogo, no caso de iOS, isso normalmente fecharia o aplicativo
        exit(0)
    }
}
