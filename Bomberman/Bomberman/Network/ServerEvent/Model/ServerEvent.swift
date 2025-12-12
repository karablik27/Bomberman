//
//  ServerEvent.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

enum ServerEvent {
    case assignID(String)
    case gameState(GameState)
    case chatMessage(ChatMessage)
}
