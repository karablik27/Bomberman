//
//  PlayersPanelView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 12.12.2025.
//

import SwiftUI

struct PlayersPanelView: View {

    let players: [Player]

    var body: some View {
        VStack(spacing: 12) {

            HStack {
                Text("PLAYERS")
                    .font(.kenneyFuture(size: 22))
                    .foregroundColor(.white)

                Spacer()

                Text("\(players.count) / 4")
                    .font(.kenneyFuture(size: 16))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.bottom, 6)

            VStack(spacing: 10) {
                ForEach(players, id: \.id) { player in
                    PlayerRowView(player: player)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.85), lineWidth: 2)
        )
    }
}
