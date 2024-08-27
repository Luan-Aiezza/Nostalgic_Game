
import Foundation
import SpriteKit

extension SKTileMapNode {
    
    //call this by passing in your SKTileMapNode, then you should delete the original SKTileMapNode
    func addPhysicsToTileMap(entityManager: SKEntityManager)
    {
        
        let tileMap = self
        
        let tileSize = tileMap.tileSize
        
        for col in 0..<tileMap.numberOfColumns {
            
            for row in 0..<tileMap.numberOfRows {
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {
                    
                    tileDefinition.textures[0].filteringMode = .nearest
                
                    let tilePosition = self.centerOfTile(atColumn: col, row: row)
                    
                    // TODO: Spawn Correct Node
                    
                    let groundEntity = SpikesEntity(size: tileSize, position: tilePosition)
                    entityManager.add(entity: groundEntity)
                    
                }
            }
        }
    }
}
