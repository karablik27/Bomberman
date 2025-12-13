//
//  PlayerRowView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 12.12.2025.
//

import SwiftUI

struct PlayerRowView: View {

    let player: Player
    let skin: PlayerSkin
    
    var body: some View {
        HStack(spacing: 12) {

            Image(skin.iconName)
                .resizable()
                .frame(width: 34, height: 34)


            VStack(alignment: .leading, spacing: 2) {
                Text(player.name)
                    .font(.kenneyFuture(size: 20))
                    .foregroundColor(.white)

                Text(player.ready ? "READY" : "NOT READY")
                    .font(.kenneyFuture(size: 14))
                    .foregroundColor(player.ready ? .green : .yellow)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.12))
        )
    }
}
