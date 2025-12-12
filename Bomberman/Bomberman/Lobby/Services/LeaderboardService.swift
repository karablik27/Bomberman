//
//  LeaderboardService.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//

import Foundation

@MainActor
class LeaderboardService {
    static let shared = LeaderboardService()
    
    private let winsKey = "playerWins"
    
    private init() {}
    
    func recordWin(for playerName: String) {
        var wins = getWins()
        wins[playerName, default: 0] += 1
        saveWins(wins)
    }
    
    func getWins() -> [String: Int] {
        guard let data = UserDefaults.standard.dictionary(forKey: winsKey) as? [String: Int] else {
            return [:]
        }
        return data
    }
    
    func getWinCount(for playerName: String) -> Int {
        return getWins()[playerName] ?? 0
    }
    
    func getSortedLeaderboard() -> [(name: String, wins: Int)] {
        let wins = getWins()
        return wins.sorted { first, second in
            if first.value == second.value {
                return first.key < second.key
            }
            return first.value > second.value
        }.map { (name: $0.key, wins: $0.value) }
    }
    
    func resetLeaderboard() {
        UserDefaults.standard.removeObject(forKey: winsKey)
    }
    
    private func saveWins(_ wins: [String: Int]) {
        UserDefaults.standard.set(wins, forKey: winsKey)
    }
}
