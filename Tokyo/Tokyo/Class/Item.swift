//
//  Item.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 01/08/24.
//

import Foundation

class Item {
    var name : String
    
    init(name: String) {
        self.name = name
    }
    
    func returnName() -> String {
       return name
    }
}

