import GameplayKit

class RenderSystem: GKComponentSystem<GKComponent> {
    func render(entities: [GKEntity], in scene: SKScene) {
        for entity in entities {
            if let spriteComponent = entity.component(ofType: SpriteComponent.self),
               let positionComponent = entity.component(ofType: PositionComponent.self) {
                spriteComponent.spriteNode.position = positionComponent.position
                
                if let scaleComponent = entity.component(ofType: ScaleComponent.self) {
                    spriteComponent.spriteNode.setScale(scaleComponent.scale)
                }
                
                if let filteringModeComponent = entity.component(ofType: FilteringModeComponent.self) {
                    spriteComponent.spriteNode.texture?.filteringMode = filteringModeComponent.filteringMode
                }
                
                if let colliderComponent = entity.component(ofType: ColliderComponent.self) {
                    spriteComponent.spriteNode.physicsBody = colliderComponent.physicsBody
                }
                
                if spriteComponent.spriteNode.parent == nil {
                    scene.addChild(spriteComponent.spriteNode)
                }
            }
        }
    }
}
