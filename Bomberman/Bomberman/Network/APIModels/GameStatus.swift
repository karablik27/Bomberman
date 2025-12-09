//
//  GameStatus.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

enum GameStatus: String, Codable {
    case waiting = "WAITING"
    case inProgress = "IN_PROGRESS"
    case gameOver = "GAME_OVER"
}

extension GameStatus {
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = GameStatus(rawValue: raw) ?? .waiting
    }
}
