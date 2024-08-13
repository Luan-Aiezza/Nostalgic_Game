import Foundation
import SpriteKit
import GameplayKit


class BossEntity: GKEntity {
    
    var body: SKPhysicsBody?
    let entityManager: SKEntityManager
    
    var moveComponent: BossMovementComponent? {
        return component(ofType: BossMovementComponent.self)
    }
    
    var animationComponent: AnimationComponent? {
        return component(ofType: AnimationComponent.self)
    }
    
    var physicsComponent: PhysicsComponent? {
        return component(ofType: PhysicsComponent.self)
    }
    
    var stateComponent: StateMachineComponent? {
        return component(ofType: StateMachineComponent.self)
    }
    
    var spriteNode: SKSpriteNode? {
        return component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    }
    
    init(entityManager: SKEntityManager) {
        self.entityManager = entityManager
        super.init()
        let node = SKSpriteNode(imageNamed: "bossIdle1")
        node.anchorPoint = .init(x: 0.5, y: 0.5)
        node.setScale(1)
        self.addComponent(GKSKNodeComponent(node: node))
        
        let moveComp = BossMovementComponent(speed: 3)
        self.addComponent(moveComp)
        
        let radius = min(node.size.width, node.size.height) / 2
        let body = SKPhysicsBody(circleOfRadius: radius)
        body.isDynamic = true
        body.restitution = 0
        body.usesPreciseCollisionDetection = true
        body.allowsRotation = false
        body.affectedByGravity = false  // Desabilitar gravidade para o Boss

        // Configura as categorias de física
        body.categoryBitMask = UInt32.boss

        // Permite contato, mas ignora a colisão com o tilemap
        body.collisionBitMask = UInt32.player
        body.contactTestBitMask = UInt32.player

        let physicsComp = PhysicsComponent(body: body)
        self.addComponent(physicsComp)
        
        let death = SKAction.sequence([
            .fadeOut(withDuration: 0.1),
            .run {
                [weak self] in
                guard let self else { return }
                entityManager.remove(entity: self)
            }])
        
        self.addComponent(DemiseComponent(death: death))
        
        let animationComp = AnimationComponent()
        self.addComponent(animationComp)
        
        let stateMachine = GKStateMachine(states: [BossIdle(bossEntity: self), BossDash(bossEntity: self), BossPause(bossEntity: self)])
        let stateComp = StateMachineComponent(stateMachine: stateMachine)
        
        self.addComponent(stateComp)
        stateComp.stateMachine.enter(BossIdle.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let node = self.component(ofType: GKSKNodeComponent.self)?.node {
            node.removeFromParent()
        }
    }
    
    func dash(to position: CGPoint, duration: TimeInterval) {
        stateComponent?.stateMachine.enter(BossDash.self)
        moveComponent?.moveToPosition(position, duration: duration)
    }
    
    func playerActions(_ animation: BossAnimation) -> SKAction {
        switch animation {
            case .idle:
                let action: SKAction = .repeatForever(.animate(with: .init(withFormat: "bossIdle%@.png", range: 1...3), timePerFrame: 0.6))
                return action
                
            case .dash:
                let action: SKAction = .animate(with: .init(withFormat: "bossDash%@.png", range: 1...3), timePerFrame: 0.1)
                return action
        }
    }
}


enum BossAnimation {
    case idle, dash
}
