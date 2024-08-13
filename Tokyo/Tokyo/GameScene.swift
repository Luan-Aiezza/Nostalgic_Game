//
//  GameScene.swift
//  Tokyo
//
//  Created by Luan Aiezza on 17/07/24.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    
    var entityManager: SKEntityManager?
    var right_button = SKSpriteNode(imageNamed: "right")
    var left_button = SKSpriteNode(imageNamed: "left")
    var jump_button = SKSpriteNode(imageNamed: "jump")
    var enemies:[GhostEntity] = []
    public var stateMachine : GKStateMachine?
    public var stateMachineEnemy : GKStateMachine?
    private var lastUpdateTime : TimeInterval = 0
    weak var playerEntity: PlayerEntity?
    var rightButtonPressed = false
    var leftButtonPressed = false
    
    override func sceneDidLoad() {
        
        self.physicsWorld.contactDelegate = self
        
        entityManager = SKEntityManager(scene: self)
        //Adicionando Level02 (CÓDIGO LUAN)
        
        //        let scenarioEntity = TilesEntity(named: "Level02.sks", entityManager: entityManager!)
        let scenarioEntity = TilesEntity(named: "Level02.sks", entityManager: entityManager!)
        entityManager?.add(entity: scenarioEntity)
        
        let cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        self.camera?.setScale(0.35)
        //FIM DO CODIGO
        
        
        //ITEMS EM CENA - JESSICA
        let playerEntity = PlayerEntity(entityManager: entityManager!)
        entityManager?.add(entity: playerEntity)
        self.playerEntity = playerEntity
        playerEntity.stateComponent?.stateMachine.enter(PlayerIdle.self)
        
        let keyItem = ItemEntity(position: CGPoint(x: 0, y: -580), size: CGSize(width: 100, height: 100), entityManager: entityManager!, sprite: "key")
        entityManager?.add(entity: keyItem)
        
        let cherryItem = CherryEntity(position: CGPoint(x: 160, y: -255), entityManager: entityManager!)
        entityManager?.add(entity: cherryItem)
        
        
        // FUNÇÃO DE ADICIONAR FANTASMAS
        ghostAdd()
        setupButtons()
        adjustButtonLayout()
        
    }
    
    func setupButtons(){
        right_button.name = "right_button"
        right_button.texture?.filteringMode = .nearest
        self.camera?.addChild(right_button)
        
        left_button.name = "left_button"
        left_button.texture?.filteringMode = .nearest
        self.camera?.addChild(left_button)
        
        jump_button.name = "jump_button"
        jump_button.texture?.filteringMode = .nearest
        self.camera?.addChild(jump_button)
        
    }
    
    func adjustButtonLayout() {
        guard let camera = self.camera else { return }
        let buttonSize = CGSize(width: 80, height: 80)
        
        right_button.size = buttonSize
        left_button.size = buttonSize
        jump_button.size = buttonSize
        
        let cameraFrame = camera.calculateAccumulatedFrame()
        
        left_button.position = CGPoint(x: cameraFrame.minX - 250, y: cameraFrame.minY - 90 )
        right_button.position = CGPoint(x: left_button.position.x + buttonSize.width + 20, y: left_button.position.y)
        
        jump_button.position = CGPoint(x: cameraFrame.maxX + 250, y:left_button.position.y)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        adjustButtonLayout()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        captureInput(touches: touches, isTouching: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        captureInput(touches: touches, isTouching: false)
        
        if !rightButtonPressed && !leftButtonPressed{
            playerEntity?.stateComponent?.stateMachine.enter(PlayerIdle.self)
            playerEntity?.moveComponent?.direction = .none
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdateTime
        
        if let entities = entityManager?.entities {
            for entity in entities {
                entity.update(deltaTime: dt)
            }
        }
        
        if let playerNode = playerEntity?.spriteNode {
            self.camera?.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 35)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    public func captureInput(touches: Set<UITouch>, isTouching: Bool) {
        guard let camera else { return }
        if let location = touches.first?.location(in: camera){
            if right_button.contains(location) {
                rightButtonPressed = isTouching
                if isTouching {
                    playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                    playerEntity?.moveComponent?.change(direction: .right)
                }
                else if !leftButtonPressed{
                    playerEntity?.moveComponent?.change(direction: .none)
                }
            }
            
            if left_button.contains(location) {
                leftButtonPressed = isTouching
                if isTouching {
                    playerEntity?.stateComponent?.stateMachine.enter(PlayerRun.self)
                    playerEntity?.moveComponent?.change(direction: .left)
                }
                else if !rightButtonPressed{
                    playerEntity?.moveComponent?.change(direction: .none)
                }
            }
            
            if jump_button.contains(location) && isTouching {
                let horizontalDirection: CGFloat = rightButtonPressed ? 1 : (leftButtonPressed ? -1 : 0)
                playerEntity?.jump(horizontalDirection: horizontalDirection)
            }
        }
    }
    
    
    // FUNÇÃOO DE REINICIAR GAME - JESSICA
    func gameOver() {
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .aspectFill
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view?.presentScene(newScene)
    }
    
    //FUNÇÃO DE ADICIONAR FANTASMA - JESSICA
    func ghostAdd(){
        let ghost1 = GhostEntity(position: CGPoint(x: 180, y: -245), entityManager: entityManager!, spriteName: "yellowGhost")
        entityManager?.add(entity: ghost1)
        enemies.append(ghost1)
        ghost1.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path1 = ghost1.moveComponent?.moveGhost(points:[CGPoint(x: 700, y: -245), CGPoint(x: 700, y: -105), CGPoint(x: 180, y: -105), CGPoint(x: 180, y: -245)], duration: [2, 1, 2, 1], direction: .left) else {return}
        let actionSequence1 = SKAction.repeatForever(SKAction.sequence(path1))
        ghost1.wanderComponent?.wander(path: actionSequence1)
        
        let ghost2 = GhostEntity(position: CGPoint(x: -280, y: -105), entityManager: entityManager!, spriteName: "pinkGhost")
        entityManager?.add(entity: ghost2)
        enemies.append(ghost2)
        ghost2.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path2 = ghost2.moveComponent?.moveGhost2WayPoints(points:[CGPoint(x: -930, y: -105), CGPoint(x: -280, y: -105)], duration: [2.5, 2.5], direction: .left) else {return}
        let actionSequence2 = SKAction.repeatForever(SKAction.sequence(path2))
        ghost2.wanderComponent?.wander(path: actionSequence2)
        
        let ghost3 = GhostEntity(position: CGPoint(x: 500, y: -375), entityManager: entityManager!, spriteName: "redGhost")
        entityManager?.add(entity: ghost3)
        enemies.append(ghost3)
        ghost3.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path3 = ghost3.moveComponent?.moveGhost2WayPoints(points:[CGPoint(x: -840, y: -375), CGPoint(x: 500, y: -375)], duration: [4, 4], direction: .left) else {return}
        let actionSequence3 = SKAction.repeatForever(SKAction.sequence(path3))
        ghost3.wanderComponent?.wander(path: actionSequence3)
        
        let ghost4 = GhostEntity(position: CGPoint(x: -940, y: -1245), entityManager: entityManager!, spriteName: "blueGhost")
        entityManager?.add(entity: ghost4)
        enemies.append(ghost4)
        ghost4.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path4 = ghost4.moveComponent?.moveGhost2WayPoints(points:[CGPoint(x: -560, y: -1245), CGPoint(x: -940, y: -1245)], duration: [2.5, 2.5], direction: .right) else {return}
        let actionSequence4 = SKAction.repeatForever(SKAction.sequence(path4))
        ghost4.wanderComponent?.wander(path: actionSequence4)
        
        let ghost5 = GhostEntity(position: CGPoint(x: -920, y: -1095), entityManager: entityManager!, spriteName: "yellowGhost")
        entityManager?.add(entity: ghost5)
        enemies.append(ghost5)
        ghost5.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path5 = ghost5.moveComponent?.moveGhostMultipleWayPoints(points:[CGPoint(x: -920, y: -965), CGPoint(x: -790, y: -965), CGPoint(x:  -790, y: -845), CGPoint(x: -470, y: -845), CGPoint(x:  -470, y: -965), CGPoint(x: -670, y: -965), CGPoint(x: -670, y: -1095),  CGPoint(x: -920, y: -1080)], duration: [1, 2, 1.5, 2.5, 1, 2, 1, 2], direction: .left) else {return}
        let actionSequence5 = SKAction.repeatForever(SKAction.sequence(path5))
        ghost5.wanderComponent?.wander(path: actionSequence5)
        
        let ghost6 = GhostEntity(position: CGPoint(x: 80, y: -1095), entityManager: entityManager!, spriteName: "redGhost")
        entityManager?.add(entity: ghost6)
        enemies.append(ghost6)
        ghost6.stateComponent?.stateMachine.enter(GhostHealthy.self)
        guard let path6 = ghost6.moveComponent?.moveGhostMultipleWayPoints(points: [CGPoint(x: 485, y: -1095), CGPoint(x: 485, y: -970), CGPoint(x: 765, y: -970), CGPoint(x: 765, y: -795), CGPoint(x: 925, y: -795), CGPoint(x: 925, y: -1245), CGPoint(x: 640, y: -1245), CGPoint(x: 640, y: -970), CGPoint(x: 485, y: -970), CGPoint(x: 485, y: -1080), CGPoint(x: 80, y: -1080)], duration: [2, 1, 1.5, 1, 1, 3, 2.5, 2.5, 1, 1, 2], direction: .left) else {return}
        let actionSequence6 = SKAction.repeatForever(SKAction.sequence(path6))
        ghost6.wanderComponent?.wander(path: actionSequence6)
        
    }
}


