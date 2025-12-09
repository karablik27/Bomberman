//
//  GameStateMessage.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

struct GameStateMessage: Codable {
    let type: String
    let payload: GameState
}
