import Foundation
import SpriteKit

extension SKTileMapNode{
    
    func addPhysicsToTileMap(entityManager: SKEntityManager){
        
        let tileMap = self
        
        let tileSize = tileMap.tileSize
        
        for col in 0..<tileMap.numberOfColumns{
            
            for row in 0..<tileMap.numberOfRows{
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                    
                    tileDefinition.textures[0].filteringMode = .nearest
                    
                    if(tileDefinition.userData?["noPhysics"] != nil) {continue}
                    //IFS para diferenciar paredes de chao
                    
                    _ = tileDefinition.textures
                    let tilePosition = self.centerOfTile(atColumn: col, row: row)
                    
                    // TODO: Spawn Correct Node
                    
                    let groundEntity = GroundEntity(size: tileSize, position: tilePosition)
                    entityManager.add(entity: groundEntity)
                    
                }
            }
        }
    }
    
    
    func drawGraph() {
        
    }
}
