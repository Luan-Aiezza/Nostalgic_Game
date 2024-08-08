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
    var node: SKNode?
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
        self.direction = direction
        var X = 0
        var lastPoint = points[0]
        
        for point in points {
            if lastPoint.x <= point.x {
                let action = SKAction.run { [self] in
                    node?.xScale = abs(node?.xScale ?? 1) * -1
                }
                path.append(action)
            }
            else if lastPoint.x > point.x {
                let action = SKAction.run { [self] in
                    node?.xScale = abs(node?.xScale ?? 1) * 1
                }
                path.append(action)
            }
            
            let pointGo = SKAction.move(to: point, duration: duration[X])
            path.append(pointGo)
            X = X+1
            lastPoint = point
        }
        print(path)
        return path
    }
}
