//
//  LobbyPlayersView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct LobbyPlayersView: View {

    private let audioService = DIContainer.shared.audioService
    @ObservedObject var vm: LobbyViewModel

    var body: some View {
        VStack(spacing: 20) {

            VStack(spacing: 8) {
                Text("LOBBY")
                    .font(.kenneyFuture(size: 40))
                    .foregroundColor(.white)

                Text("Players: \(vm.players.count)/4")
                    .font(.kenneyFuture(size: 18))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.top, 20)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(vm.players) { player in
                        HStack(spacing: 12) {
                            Image("PlayerIcon")
                                .resizable()
                                .frame(width: 32, height: 32)

                            Text(player.name)
                                .foregroundColor(.white)
                                .font(.kenneyFuture(size: 24))

                            Spacer()

                            Text(player.ready ? "READY" : "NOT READY")
                                .foregroundColor(player.ready ? .green : .yellow)
                                .font(.kenneyFuture(size: 22))
                        }
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                }
            }

            Spacer()

            Button {
                audioService.playReadySound()
                vm.toggleReady()
            } label: {
                Text(vm.isReady ? "UNREADY" : "READY")
                    .font(.kenneyFuture(size: 30))
                    .foregroundColor(.white)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 18)
                    .background(vm.isReady ? Color.gray : Color.green)
                    .cornerRadius(16)
            }

            Button {
                audioService.playButtonSound()
                vm.leaveLobby()
            } label: {
                Text("LEAVE")
                    .font(.kenneyFuture(size: 22))
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

            Spacer().frame(height: 40)
        }
    }
}
