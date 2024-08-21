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
        var lastIndex = 0
        
        let moveDirectonOnce = SKAction.run {
            self.change(direction: direction)
        }
        
        path.append(moveDirectonOnce)
        
        for point in 0...points.count-1 {
            let pointGo = SKAction.move(to: points[point], duration: duration[point])
            path.append(pointGo)
            
            if point != 0 {
                lastIndex = point-1
            }
            else {
                lastIndex = point
            }
            
            if points[point].x >= points[lastIndex].x{
                let moveDirecton = SKAction.run {
                    self.node?.xScale = abs(self.node?.xScale ?? 1) * 1
                }
                path.append(moveDirecton)
            }
            else{
                let moveDirecton = SKAction.run {
                    self.node?.xScale = abs(self.node?.xScale ?? 1) * -1
                }
                path.append(moveDirecton)
            }
            
        }
        return path
    }
    
    
    public func moveGhost2WayPoints(points : [CGPoint], duration: [TimeInterval], direction : Direction) -> [SKAction] {
        var path : [SKAction] = []
        self.direction = direction
        var X = 0
        var lastPoint = points[0]
        
        for point in points {
            
            let pointGo = SKAction.move(to: point, duration: duration[X])
            path.append(pointGo)
            
            if lastPoint.x < point.x {
                let action = SKAction.run { [self] in
                    node?.xScale = abs(node?.xScale ?? 1) * 1
                }
                path.append(action)
            }
            else if lastPoint.x > point.x {
                let action = SKAction.run { [self] in
                    node?.xScale = abs(node?.xScale ?? 1) * -1
                }
                path.append(action)
            }
            else if lastPoint.x == point.x {
                let action = SKAction.run { [self] in
                    node?.xScale = abs(node?.xScale ?? 1) * self.direction.rawValue
                }
                path.append(action)
            }
            X = X+1
            lastPoint = point
        }
        return path
    }
    
    public func moveGhostMultipleWayPoints(points : [CGPoint], duration: [TimeInterval], direction : Direction) -> [SKAction] {
        var path : [SKAction] = []
        self.direction = direction
        var lastPoint = points[0]
        var X = 0
        
        let moveDirectonOnce = SKAction.run {
            self.change(direction: direction)
        }
        
        path.append(moveDirectonOnce)
        
        for point in points {
            
            var direction = self.direction.rawValue
            let pointGo = SKAction.move(to: point, duration: duration[X])
            
            if lastPoint.x != point.x {
                let action = SKAction.run { 
                    [self] in
                    direction = direction * -1
                    node?.xScale = abs(node?.xScale ?? 1) * direction}
                path.append(action)}
            
            else {
                let action = SKAction.run { [self] in
                    node?.xScale = abs(node?.xScale ?? 1) * self.direction.rawValue}
                path.append(action)}
            
            X = X+1
            lastPoint = point
            path.append(pointGo)
        }
        
        return path
    }
    

    
    
    public func stop() {
        self.change(direction: .none)
    }
}
