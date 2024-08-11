//
//  WanderComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 30/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

class WanderComponent : GKComponent {
    
    var path : SKAction = SKAction()
    weak var node : SKNode?
    
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
    }
    
    public func path (path : SKAction){
        self.path = path
    }
    
    public func wander(path : SKAction){
        node?.run(path, withKey: "moving")
    }
    
//    func moveRight(point : CGPoint, time : TimeInterval){
//        node?.xScale = abs(node?.xScale ?? 1) * 1
//        node?.run(SKAction.move(to: point, duration: 1))
//    }
//    
//    func moveLeft(point : CGPoint, time : TimeInterval){
//        node?.run(SKAction.group([.run { [self] in
//            node?.run(SKAction.move(to: point, duration: 1))
//        }, .run { [self] in
//            node?.xScale = abs(node?.xScale ?? 1) * -1
//        }]))
//    }
//    
//    func moveUp(point : CGPoint, time : TimeInterval){
//        node?.run(SKAction.move(to: point, duration: 1))
//    }
//    
//    func moveDown(point : CGPoint, time : TimeInterval){
//        node?.run(SKAction.move(to: point, duration: 1))
//    }
}


