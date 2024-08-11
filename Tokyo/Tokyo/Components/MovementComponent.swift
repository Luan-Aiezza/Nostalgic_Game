//
//  MovementComponent.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 23/07/24.
//

import Foundation
import SpriteKit
import GameplayKit


enum Direction: CGFloat{
    case right = 1
    case left = -1
    case none = 0
}

class MovementComponent: GKComponent {
    weak var node: SKNode?
    var speed: CGFloat
    var direction: Direction = .none
    var animationComp: AnimationComponent?
    
    init(speed: CGFloat) {
        self.speed = speed
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
        animationComp = entity?.component(ofType: AnimationComponent.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        node?.position.x += direction.rawValue * speed
    }
    
    public func change(direction: Direction) {
        self.direction = direction
        
        if(direction != .none) {
            node?.xScale = abs(node?.xScale ?? 1) * direction.rawValue
        }
    }
    
    public func moveGhost(points : [CGPoint], duration: [TimeInterval], direction : Direction) -> [SKAction] {
        var path : [SKAction] = []
        
        let moveDirectonOnce = SKAction.run {
            self.change(direction: direction)
        }
        
        path.append(moveDirectonOnce)
    
        for point in 0...points.count-1 {
            let pointGo = SKAction.move(to: points[point], duration: duration[point])
            path.append(pointGo)
            
            var nextIndex = point+1
            
            if nextIndex <= points.count-1{
                if points[point].x <= points[nextIndex].x{
                    let moveDirecton = SKAction.run {
                        self.change(direction: .left)
                    }
                    path.append(moveDirecton)
                }
                else{
                    let moveDirecton = SKAction.run {
                        self.change(direction: .right)
                    }
                    path.append(moveDirecton)
                }
            }
        }
        print(path)
        return path
    }
}
