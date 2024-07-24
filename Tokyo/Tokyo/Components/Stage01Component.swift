import SpriteKit
import GameplayKit

class PositionComponent: GKComponent {
    var position: CGPoint
    
    init(position: CGPoint) {
        self.position = position
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SpriteComponent: GKComponent {
    var spriteNode: SKSpriteNode
    
    init(spriteNode: SKSpriteNode) {
        self.spriteNode = spriteNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScaleComponent: GKComponent {
    var scale: CGFloat
    
    init(scale: CGFloat) {
        self.scale = scale
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FilteringModeComponent: GKComponent {
    var filteringMode: SKTextureFilteringMode
    
    init(filteringMode: SKTextureFilteringMode) {
        self.filteringMode = filteringMode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColliderComponent: GKComponent {
    var physicsBody: SKPhysicsBody
    
    init(physicsBody: SKPhysicsBody) {
        self.physicsBody = physicsBody
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
