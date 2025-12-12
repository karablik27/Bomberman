//
//  LeaderboardView.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//


import SwiftUI

struct LeaderboardView: View {
    @StateObject private var vm: LeaderboardViewModel

    init(
        leaderboardService: LeaderboardServiceProtocol = DIContainer.shared.leaderboardService
    ) {
        _vm = StateObject(
            wrappedValue: LeaderboardViewModel(
                leaderboardService: leaderboardService
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            title

            if vm.leaderboard.isEmpty {
                emptyState
            } else {
                leaderboardList
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(background)
        .overlay(border)
        .onAppear { vm.load() }
    }
}

private extension LeaderboardView {

    var title: some View {
        Text("ЛИДЕРБОРД")
            .font(.kenneyFuture(size: 24))
            .foregroundColor(.white)
            .padding(.bottom, 12)
    }

    var emptyState: some View {
        Text("Нет статистики")
            .font(.kenneyFuture(size: 18))
            .foregroundColor(.white.opacity(0.6))
            .padding(.vertical, 20)
    }

    var leaderboardList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(
                    Array(vm.leaderboard.enumerated()),
                    id: \.element.name
                ) { index, entry in
                    LeaderboardRow(index: index, entry: entry)
                }
            }
        }
        .frame(maxHeight: 200)
    }

    var background: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.black.opacity(0.95))
    }

    var border: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.white.opacity(0.85), lineWidth: 2.5)
    }
}
