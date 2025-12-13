//
//  PlayerSkin.swift
//  Bomberman
//
//  Created by Alexandra Lazareva on 13.12.2025.
//

enum PlayerSkin: String, CaseIterable, Identifiable {
    case blue, green, red, turquoise

    var id: String { rawValue }

    var spritePrefix: String {
        switch self {
        case .blue: return "BluePlayer"
        case .green: return "GreenPlayer"
        case .red: return "RedPlayer"
        case .turquoise: return "TurquoisePlayer"
        }
    }

    var iconName: String {
        "\(spritePrefix)Icon"
    }
}


