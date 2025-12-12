//
//  LeaderboardBackView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 12.12.2025.
//

import SwiftUI

struct LeaderboardBackView: View {

    let audioService: AudioServiceProtocol
    let leaderboardService: LeaderboardServiceProtocol

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            KenneyBlocksBackground(style: .trophies)

            VStack {
                HStack {
                    Button {
                        audioService.playButtonSound()
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                            Text("BACK")
                                .font(.kenneyFuture(size: 20))
                        }
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    }
                    Spacer()
                }
                .padding(.top, 10)

                Spacer().frame(height: 100)

                LeaderboardView(
                    leaderboardService: leaderboardService
                )
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
