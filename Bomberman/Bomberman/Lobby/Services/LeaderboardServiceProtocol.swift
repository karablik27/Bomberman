//
//  LeaderboardServiceProtocol.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 12.12.2025.
//

@MainActor
protocol LeaderboardServiceProtocol {
    func recordWin(for playerName: String)
    func getWins() -> [String: Int]
    func getWinCount(for playerName: String) -> Int
    func getSortedLeaderboard() -> [(name: String, wins: Int)]
    func resetLeaderboard()
}
