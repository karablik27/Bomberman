//
//  LeaderboardRow.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 12.12.2025.
//

import SwiftUI

struct LeaderboardRow: View {
    let index: Int
    let entry: (name: String, wins: Int)

    var body: some View {
        HStack(spacing: 12) {

            Text("\(index + 1)")
                .font(.kenneyFuture(size: 20))
                .foregroundColor(.white)
                .frame(width: 30)

            Text(entry.name)
                .font(.kenneyFuture(size: 18))
                .foregroundColor(.white)

            Spacer()

            HStack(spacing: 4) {
                Text("\(entry.wins)")
                    .font(.kenneyFuture(size: 18))
                    .foregroundColor(.yellow)

                Image("trophy")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(rowBackground)
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                index == 0
                ? Color.yellow.opacity(0.3)
                : Color.white.opacity(0.2)
            )
    }
}
