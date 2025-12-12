//
//  BackgroundDropStyle.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 12.12.2025.
//

enum BackgroundDropStyle {
    case blocks
    case trophies

    var images: [String] {
        switch self {
        case .blocks:
            return ["block_01", "block_02", "block_03", "block_04"]

        case .trophies:
            return ["trophy"]
        }
    }
}
