//
//  PlayerDirection.swift
//  Bomberman
//
//  Created by Kashapov Amir on 10.12.2025.
//

enum PlayerDirection: String {
    case up
    case down
    case left
    case right
    
    var spriteName: String {
        switch self {
        case .up: return "PlayerUp"
        case .down: return "PlayerDown"
        case .left: return "PlayerLeft"
        case .right: return "PlayerRight"
        }
    }
    
    var animationFrames: [String] {
        switch self {
        case .up: return ["PlayerUp", "PlayerUp2", "PlayerUp3"]
        case .down: return ["PlayerDown", "PlayerDown2", "PlayerDown3"]
        case .left: return ["PlayerLeft", "PlayerLeft2", "PlayerLeft3"]
        case .right: return ["PlayerRight", "PlayerRight2", "PlayerRight3"]
        }
    }
}