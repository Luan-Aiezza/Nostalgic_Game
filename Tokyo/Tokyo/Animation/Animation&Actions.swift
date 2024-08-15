//
//  Animation&Actions.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 26/07/24.
//

import Foundation
import SpriteKit
import GameplayKit

public enum PlayerAnimation {
    case idle
    case run
    case death
    case eat
    case wallSlide
}

enum GhostAnimation {
    case dizzy
    case healthy
    case death
}

enum PointAnimation {
    case chest
    case stone
}
