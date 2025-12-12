//
//  LobbyViewModel.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class LobbyViewModel: ObservableObject {

    @Published var players: [Player] = []
    @Published var myID: String?
    @Published var isReady: Bool = false
    @Published var gameStarted: Bool = false
    @Published var didJoin: Bool = false

    private let store: GameStateStore
    private var cancellables = Set<AnyCancellable>()

    init(store: GameStateStore = DIContainer.shared.gameStateStore) {
        self.store = store
        resetState()
        bind()
    }

    private func bind() {
        store.$playerID
            .sink { [weak self] id in
                self?.myID = id
                if id == nil {
                    self?.isReady = false
                }
            }
            .store(in: &cancellables)

        store.$gameState
            .sink { [weak self] state in
                guard let self else { return }
                
                guard let state else {
                    self.players = []
                    self.isReady = false
                    self.gameStarted = false
                    return
                }
                self.players = state.players

                if let id = self.myID,
                   let me = state.players.first(where: { $0.id == id }) {
                    self.isReady = me.ready
                }

                switch state.state {
                case .inProgress:
                    if self.gameStarted == false && self.myID != nil {
                        self.gameStarted = true
                    }
                case .waiting:
                    if self.gameStarted {
                        break
                    } else {
                        self.gameStarted = false
                    }
                case .gameOver:
                    break
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func connectAndJoin(with name: String) {
        resetState()
        store.connect()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let joinJSON = """
            {
                "type": "join",
                "role": "player",
                "name": "\(name)"
            }
            """
            self.store.send(joinJSON)
            withAnimation(.easeInOut(duration: 0.35)) {
                self.didJoin = true
            }
        }
    }

    func toggleReady() {
        store.send(#"{"type":"ready"}"#)
    }

    func leaveLobby() {
        resetState()
        store.disconnect()
        withAnimation(.easeInOut(duration: 0.35)) {
            didJoin = false
        }
    }
    
    func resetState() {
        players = []
        myID = nil
        isReady = false
        gameStarted = false
    }
}
