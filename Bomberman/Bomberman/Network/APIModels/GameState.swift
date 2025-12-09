//
//  GameState.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

struct GameState: Codable {
    let state: GameStatus
    let winner: String?
    let time_remaining: Double?
    let map: [[String]]
    let players: [Player]
    let bombs: [Bomb]
    let explosions: [Explosion]
}
