//
//  InventoryComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 31/07/24.
//

import Foundation
import GameplayKit
import SpriteKit

class IventoryComponent : GKComponent {
    
    var  node : SKNode?
    var items: [Item] = []
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    public func addItem(item : Item){
        items.append(item)
    }
}
