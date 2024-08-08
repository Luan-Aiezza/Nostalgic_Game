//
//  IdentifierComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 01/08/24.
//

import Foundation
import SpriteKit
import GameplayKit


class IdentifierComponent : GKComponent {
    
    var  node : SKNode?
    var name : String = ""
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    func name(name : String) {
        self.name =  name
    }
    
    func returnName() -> String{
        return self.name
    }
}

