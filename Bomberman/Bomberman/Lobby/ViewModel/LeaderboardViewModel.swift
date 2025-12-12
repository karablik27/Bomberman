//
//  LeaderboardViewModel.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI
import Combine 

@MainActor
final class LeaderboardViewModel: ObservableObject {

    @Published var leaderboard: [(name: String, wins: Int)] = []

    private let leaderboardService: LeaderboardServiceProtocol

    init(
        leaderboardService: LeaderboardServiceProtocol
    ) {
        self.leaderboardService = leaderboardService
    }

    func load() {
        leaderboard = leaderboardService.getSortedLeaderboard()
    }
}
