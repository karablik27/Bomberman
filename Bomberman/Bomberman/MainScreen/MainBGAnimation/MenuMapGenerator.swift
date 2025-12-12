//
//  MenuMapGenerator.swift
//  Bomberman
//
//  Created by Верховный Маг on 13.12.2025.
//

struct MenuMapGenerator {

    static func tile(at x: Int, y: Int) -> MenuTile {
        let seed = abs(x * 73856093 ^ y * 19349663)
        let r = seed % 100

        if r < 12 { return .wall }
        if r < 30 { return .brick }
        return .floor
    }
}
