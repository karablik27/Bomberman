//
//  GameViewModel.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import Foundation
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    
    @Published var gameState: GameState?
    @Published var myID: String?
    @Published var gameStatus: GameStatus = .waiting
    @Published var winner: String?
    @Published var timeRemaining: Double?
    
    @Published var map: [[String]] = []
    @Published var players: [Player] = []
    @Published var bombs: [Bomb] = []
    @Published var explosions: [Explosion] = []
    
    private let store: GameStateStore
    private var cancellables = Set<AnyCancellable>()
    
    init(store: GameStateStore = DIContainer.shared.gameStateStore) {
        self.store = store
        bind()
    }
    
    private func bind() {
        store.$playerID
            .sink { [weak self] id in
                self?.myID = id
            }
            .store(in: &cancellables)
        
        store.$gameState
            .sink { [weak self] state in
                guard let self, let state else { return }
                self.gameState = state
                self.gameStatus = state.state
                self.winner = state.winner
                self.timeRemaining = state.time_remaining
                self.map = state.map
                self.players = state.players
                self.bombs = state.bombs
                self.explosions = state.explosions
            }
            .store(in: &cancellables)
    }
    
    
    func moveUp() {
        sendMove(dx: 0, dy: -1)
    }
    
    func moveDown() {
        sendMove(dx: 0, dy: 1)
    }
    
    func moveLeft() {
        sendMove(dx: -1, dy: 0)
    }
    
    func moveRight() {
        sendMove(dx: 1, dy: 0)
    }
    
    func placeBomb() {
        send(PlaceBombMessage())
    }
    
    private func sendMove(dx: Int, dy: Int) {
        send(MoveMessage(dx: dx, dy: dy))
    }
    
    private func send<T: Encodable>(_ message: T) {
        guard let data = try? JSONEncoder().encode(message),
              let json = String(data: data, encoding: .utf8) else {
            return
        }
        store.send(json)
    }
    
    func leaveGame() {
        store.disconnect()
    }

    
    var myPlayer: Player? {
        guard let myID else { return nil }
        return players.first { $0.id == myID }
    }
    
    var isAlive: Bool {
        myPlayer?.alive ?? false
    }
    
    var isGameOver: Bool {
        gameStatus == .gameOver
    }
    
    var isPlaying: Bool {
        gameStatus == .inProgress
    }
    
    var formattedTime: String {
        guard let time = timeRemaining else { return "--:--" }
        let totalSeconds = max(0, Int(time))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}