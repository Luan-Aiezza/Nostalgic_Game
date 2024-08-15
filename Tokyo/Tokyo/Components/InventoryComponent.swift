//
//  InventoryComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 01/08/24.
//

import Foundation
import GameplayKit
import SpriteKit

class InventoryComponent : GKComponent {
    
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
    
    public func removeItems(){
        items.removeAll()
    }
}
