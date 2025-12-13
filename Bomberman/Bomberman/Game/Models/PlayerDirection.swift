//
//  PlayerDirection.swift
//  Bomberman
//
//  Created by Kashapov Amir on 10.12.2025.
//

enum PlayerDirection: String {
    case up, down, left, right

    var spriteSuffix: String {
        switch self {
        case .up: return "Up"
        case .down: return "Down"
        case .left: return "Left"
        case .right: return "Right"
        }
    }

    var animationSuffixes: [String] {
        switch self {
        case .up: return ["Up", "Up2", "Up3"]
        case .down: return ["Down", "Down2", "Down3"]
        case .left: return ["Left", "Left2", "Left3"]
        case .right: return ["Right", "Right2", "Right3"]
        }
    }
}
