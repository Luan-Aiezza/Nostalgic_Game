//
//  SKSpriteNode+Tools.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 09/08/24.
//



import Foundation
import SpriteKit

extension SKSpriteNode {
    
    func addPhysicsToWall(entityManager: SKEntityManager){
        
        let entity = WallEntity(node: self)
        
        entityManager.add(entity: entity)
    }
    
    func addPhysicsToGround(entityManager: SKEntityManager){
        
        let entity = GroundEntity(node: self)
        
        entityManager.add(entity: entity)
    }
    
    func rendenringStone(entityManager: SKEntityManager){
        
        let entity = GroundEntity(node: self)
        
        entityManager.add(entity: entity)
    }
}
