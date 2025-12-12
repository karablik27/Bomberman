//
//  LeaderboardView.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//


import SwiftUI

struct LeaderboardView: View {
    @State private var leaderboard: [(name: String, wins: Int)] = []
    
    var body: some View {
        VStack(spacing: 0) {
            Text("ЛИДЕРБОРД")
                .font(.kenneyFuture(size: 24))
                .foregroundColor(.white)
                .padding(.bottom, 12)
            
            if leaderboard.isEmpty {
                Text("Нет статистики")
                    .font(.kenneyFuture(size: 18))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.vertical, 20)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(Array(leaderboard.enumerated()), id: \.element.name) { index, entry in
                            HStack(spacing: 12) {
                                // Место
                                Text("\(index + 1)")
                                    .font(.kenneyFuture(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 30)
                                
                                // Имя игрока
                                Text(entry.name)
                                    .font(.kenneyFuture(size: 18))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                // Количество побед
                                HStack(spacing: 4) {
                                    Text("\(entry.wins)")
                                        .font(.kenneyFuture(size: 18))
                                        .foregroundColor(.yellow)
                                    
                                    Text("W")
                                        .font(.kenneyFuture(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(index == 0 ? Color.yellow.opacity(0.2) : Color.white.opacity(0.1))
                            )
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
        .onAppear {
            updateLeaderboard()
        }
    }
    
    private func updateLeaderboard() {
        leaderboard = LeaderboardService.shared.getSortedLeaderboard()
    }
}
