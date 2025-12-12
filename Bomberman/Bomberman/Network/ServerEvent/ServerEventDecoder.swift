//
//  ServerEventDecoder.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation

struct ServerEventDecoder: ServerEventDecoderProtocol {

    private let decoder = JSONDecoder()

    func decode(_ text: String) -> ServerEvent? {
        guard let data = text.data(using: .utf8) else { return nil }

        guard let base = try? decoder.decode(BaseMessage.self, from: data) else {
            return nil
        }

        switch base.type {
        case "assign_id":
            guard let msg = try? decoder.decode(AssignIDMessage.self, from: data) else { return nil }
            return .assignID(msg.payload)

        case "game_state":
            guard let msg = try? decoder.decode(GameStateMessage.self, from: data) else { return nil }
            return .gameState(msg.payload)
        
        case "chat_message":
            guard let msg = try? decoder.decode(ChatMessages.self, from: data) else { return nil }
            return .chatMessage(msg.payload)

        default:
            return nil
        }
    }
}
