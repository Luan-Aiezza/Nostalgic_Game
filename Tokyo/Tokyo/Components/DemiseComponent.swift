
import Foundation
import SpriteKit
import GameplayKit


class DemiseComponent : GKComponent {
    
    weak var  node : SKNode?
    var death : SKAction
    
    init(death: SKAction) {
        self.death = death
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    public func die(){
        node?.removeAllActions()
        node?.run(death)
    }
    
}
