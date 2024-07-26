//
//  SKPhysicsMask.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 25/07/24.
//

import Foundation


public extension UInt32 {
    
    static let base:  UInt32 = 0b1
    static let player = UInt32.base << 0
    static let ghost = UInt32.base << 1
    
    
    static var allMasks: [UInt32] = [
        .player,
        .ghost
    ]
    
    static func contactWithAllCategories(less: [UInt32] = []) -> UInt32 {
        var result: UInt32 = 0b00
        
        for category in UInt32.allMasks {
            if !less.contains(category){
                result |= category
            }
        }
       return result
    }
}
