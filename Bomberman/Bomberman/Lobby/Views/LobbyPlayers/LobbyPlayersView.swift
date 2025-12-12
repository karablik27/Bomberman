//
//  LobbyPlayersView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct LobbyPlayersView: View {

    @ObservedObject var vm: LobbyViewModel

    private let audioService: AudioServiceProtocol
    private let leaderboardService: LeaderboardServiceProtocol

    @State private var showLeaderboardScreen = false

    init(
        vm: LobbyViewModel,
        audioService: AudioServiceProtocol,
        leaderboardService: LeaderboardServiceProtocol
    ) {
        self.vm = vm
        self.audioService = audioService
        self.leaderboardService = leaderboardService
    }

    var body: some View {
        VStack(spacing: 20) {

            VStack(spacing: 6) {
                Text("LOBBY")
                    .font(.kenneyFuture(size: 46))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.9), radius: 10)

                HStack(spacing: 20) {
                    Text("Players: \(vm.players.count)/4")
                        .font(.kenneyFuture(size: 20))
                        .foregroundColor(.white.opacity(0.75))

                    Button {
                        audioService.playButtonSound()
                        showLeaderboardScreen = true
                    } label: {
                        Image("leaderboard")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.yellow)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.yellow.opacity(0.2))
                            )
                    }
                }
            }
            .padding(.top, 40)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    ForEach(vm.players, id: \.id) { player in
                        HStack(spacing: 14) {
                            Image("PlayerIcon")
                                .resizable()
                                .frame(width: 36, height: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(player.name)
                                    .font(.kenneyFuture(size: 22))
                                    .foregroundColor(.white)

                                Text(player.ready ? "READY" : "NOT READY")
                                    .font(.kenneyFuture(size: 16))
                                    .foregroundColor(player.ready ? .green : .yellow)
                            }

                            Spacer()
                        }
                        .playerCard()
                        .padding(.horizontal, 22)
                    }
                }
                .padding(.top, 12)
            }

            Spacer()

            Button {
                audioService.playReadySound()
                vm.toggleReady()
            } label: {
                Text(vm.isReady ? "UNREADY" : "READY")
                    .font(.kenneyFuture(size: 30))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
            }
            .gameButtonStyle(color: vm.isReady ? .gray : .green)
            .padding(.horizontal, 40)

            Button {
                vm.leaveLobby()
            } label: {
                Text("LEAVE")
                    .font(.kenneyFuture(size: 22))
                    .foregroundColor(.red)
            }
            .padding(.bottom, 30)
        }
        .navigationDestination(isPresented: $showLeaderboardScreen) {
            LeaderboardBackView(
                audioService: audioService,
                leaderboardService: leaderboardService
            )
        }
    }
}
