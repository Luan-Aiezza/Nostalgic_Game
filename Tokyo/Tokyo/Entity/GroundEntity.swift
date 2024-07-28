import Foundation
import GameplayKit
import SpriteKit

class GroundEntity: GKEntity{
    
    init(size: CGSize, position: CGPoint){
        super.init()
        
        let node = SKSpriteNode(color: .blue, size: size)//tirar o azul depois
        node.position = position
        self.addComponent(GKSKNodeComponent(node: node))
        
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.affectedByGravity = false
        self.addComponent(PhysicsComponent(body: body))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
