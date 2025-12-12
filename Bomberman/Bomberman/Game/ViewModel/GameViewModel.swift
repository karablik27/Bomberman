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
    
    @Published var playerDirections: [String: PlayerDirection] = [:]
    
    private var previousPositions: [String: (x: Int, y: Int)] = [:]
    private var previousExplosions: Set<String> = []
    private var lastWinner: String?
    
    private let store: GameStateStore
    private let audioService: AudioServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(store: GameStateStore = DIContainer.shared.gameStateStore) {
        self.store = store
        self.audioService = DIContainer.shared.audioService
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

                if state.state == .waiting && self.gameStatus != .waiting {
                    self.playerDirections.removeAll()
                    self.previousPositions.removeAll()
                    self.previousExplosions.removeAll()
                    self.lastWinner = nil
                }
                
                self.updatePlayerDirections(newPlayers: state.players)
                self.detectNewExplosions(newExplosions: state.explosions)
                
                if state.state == .gameOver, let winner = state.winner, winner != "НИЧЬЯ" {
                    if self.lastWinner != winner {
                        self.lastWinner = winner
                        LeaderboardService.shared.recordWin(for: winner)
                    }
                }
                
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
    
    private func detectNewExplosions(newExplosions: [Explosion]) {
        let currentExplosionKeys = Set(newExplosions.map { "\($0.x),\($0.y)" })
        let newExplosionKeys = currentExplosionKeys.subtracting(previousExplosions)
        
        if !newExplosionKeys.isEmpty {
            audioService.playExplosionSound()
        }
        
        previousExplosions = currentExplosionKeys
    }
    
    
    func moveUp() {
        sendMove(dx: 0, dy: -1, direction: .up)
    }
    
    func moveDown() {
        sendMove(dx: 0, dy: 1, direction: .down)
    }
    
    func moveLeft() {
        sendMove(dx: -1, dy: 0, direction: .left)
    }
    
    func moveRight() {
        sendMove(dx: 1, dy: 0, direction: .right)
    }
    
    func placeBomb() {
        send(PlaceBombMessage())
    }
    
    private func sendMove(dx: Int, dy: Int, direction: PlayerDirection) {
        if let myID {
            playerDirections[myID] = direction
        }
        send(MoveMessage(dx: dx, dy: dy))
    }
    
    func direction(for playerID: String) -> PlayerDirection {
        playerDirections[playerID] ?? .down
    }
    
    private func updatePlayerDirections(newPlayers: [Player]) {
        for player in newPlayers {
            if let previous = previousPositions[player.id] {
                let dx = player.x - previous.x
                let dy = player.y - previous.y
                
                if dx != 0 || dy != 0 {
                    let newDirection = directionFromDelta(dx: dx, dy: dy)
                    playerDirections[player.id] = newDirection
                }
            }
            
            previousPositions[player.id] = (x: player.x, y: player.y)
        }
    }
    
    private func directionFromDelta(dx: Int, dy: Int) -> PlayerDirection {
        if dx > 0 { return .right }
        if dx < 0 { return .left }
        if dy > 0 { return .down }
        if dy < 0 { return .up }
        return .down // Default
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
