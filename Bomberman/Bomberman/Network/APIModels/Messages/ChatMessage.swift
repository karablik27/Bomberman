//
//  ChatMessage.swift
//  Bomberman
//
//  Created by Sergey on 13.12.2025.
//

import Foundation

struct ChatMessage: Codable, Identifiable {
    let id: String
    let playerID: String
    let playerName: String
    let message: String
    let timestamp: TimeInterval
    
    init(playerID: String, playerName: String, message: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.id = UUID().uuidString
        self.playerID = playerID
        self.playerName = playerName
        self.message = message
        self.timestamp = timestamp
    }
}
