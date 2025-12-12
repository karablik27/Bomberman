//
//  LeaderboardService.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//

import Foundation

@MainActor
final class LeaderboardService: LeaderboardServiceProtocol {

    private let winsKey = "playerWins"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func recordWin(for playerName: String) {
        var wins = getWins()
        wins[playerName, default: 0] += 1
        saveWins(wins)
    }

    func getWins() -> [String: Int] {
        guard let data = userDefaults.dictionary(forKey: winsKey) as? [String: Int] else {
            return [:]
        }
        return data
    }

    func getWinCount(for playerName: String) -> Int {
        getWins()[playerName] ?? 0
    }

    func getSortedLeaderboard() -> [(name: String, wins: Int)] {
        getWins()
            .sorted {
                $0.value == $1.value
                    ? $0.key < $1.key
                    : $0.value > $1.value
            }
            .map { (name: $0.key, wins: $0.value) }
    }

    func resetLeaderboard() {
        userDefaults.removeObject(forKey: winsKey)
    }

    private func saveWins(_ wins: [String: Int]) {
        userDefaults.set(wins, forKey: winsKey)
    }
}
