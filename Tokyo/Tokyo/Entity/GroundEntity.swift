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
        body.categoryBitMask = .tile
        self.addComponent(PhysicsComponent(body: body))
        
        // Configurando lightingBitMask e shadowBitMasks para interagir com a luz
        node.lightingBitMask = 1       // A máscara que será afetada pela luz
        node.shadowCastBitMask = 1     // Permite que o jogador lance sombras
        node.shadowedBitMask = 1       // Permite que o jogador seja sombreado
        node.color = .white            // Cor base do sprite
        node.colorBlendFactor = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
