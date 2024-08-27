//
//  SKPhysicsMask.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 25/07/24.
//

import Foundation


public extension UInt32 {
    
    static let none: UInt32 = 0
    static let boss: UInt32 = 0x1 << 2
    static let base:  UInt32 = 0b1
    static let player = UInt32.base << 0
    static let ghost : UInt32 = 0x1 << 1
    static let tempMask = UInt32.base << 10
    
    static let items = UInt32.base << 3
    static let points = UInt32.base << 3
    static let tile = UInt32.base << 4
    static let trigger = UInt32.base << 5
    
    static var allMasks: [UInt32] = [
        .player,
        .ghost,
        .tempMask,
        .items,
        .points,
        .tile,
        .trigger
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
