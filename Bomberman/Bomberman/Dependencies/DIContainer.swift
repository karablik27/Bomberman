//
//  DIContainer.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation

final class DIContainer {
    public static let shared = DIContainer()

    let webSocketService: WebSocketServiceProtocol
    let eventDecoder: ServerEventDecoderProtocol
    let gameStateStore: GameStateStore

    private init() {
        self.webSocketService = WebSocketService(url: AppConfig.webSocketURL)
        self.eventDecoder = ServerEventDecoder()
        self.gameStateStore = GameStateStore(ws: webSocketService, decoder: eventDecoder)
    }
}
