//
//  GameStateStore.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation
import Combine

@MainActor
final class GameStateStore: ObservableObject {

    @Published var gameState: GameState?
    @Published var playerID: String?
    @Published var connectionState: WebSocketConnectionState = .disconnected

    private let ws: WebSocketServiceProtocol
    private let decoder: ServerEventDecoderProtocol
    private var cancellables = Set<AnyCancellable>()

    init(ws: WebSocketServiceProtocol, decoder: ServerEventDecoderProtocol) {
        self.ws = ws
        self.decoder = decoder
        bind()
    }

    func bind() {
        ws.messagePublisher
            .sink { [weak self] text in
                guard let event = self?.decoder.decode(text) else { return }
                self?.handle(event)
            }
            .store(in: &cancellables)

        ws.connectionStatePublisher
            .assign(to: &$connectionState)
    }

    private func handle(_ event: ServerEvent) {
        switch event {
        case .assignID(let id):
            playerID = id

        case .gameState(let state):
            gameState = state
        }
    }

    func connect() { ws.connect() }
    
    func disconnect() {
        gameState = nil
        playerID = nil
        ws.disconnect()
    }

    func send(_ text: String) {
        ws.send(text)
    }
}
