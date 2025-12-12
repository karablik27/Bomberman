//
//  DIContainer.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation

@MainActor
final class DIContainer {
    public static let shared = DIContainer()

    let webSocketService: WebSocketServiceProtocol
    let eventDecoder: ServerEventDecoderProtocol
    let gameStateStore: GameStateStore
    let audioService: AudioServiceProtocol
    let leaderboardService: LeaderboardServiceProtocol
    let gameSettings: GameSettingsProtocol

    private init() {
        self.webSocketService = WebSocketService(url: AppConfig.webSocketURL)
        self.eventDecoder = ServerEventDecoder()
        self.gameStateStore = GameStateStore(ws: webSocketService, decoder: eventDecoder)
        self.audioService = AudioService()
        self.leaderboardService = LeaderboardService()
        self.gameSettings = GameSettings() 
    }
}
