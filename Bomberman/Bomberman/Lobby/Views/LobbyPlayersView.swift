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
                    .font(.kenneyFuture(size: 44))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.8), radius: 6, x: 0, y: 0)
                    .padding(.top, 30)


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
                                .frame(width: 34, height: 34)

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
                        .pixelPanel()
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
                    .font(.kenneyFuture(size: 32))
                    .foregroundColor(.white)
                    .frame(width: 260, height: 70)
                    .background(vm.isReady ? Color.gray : Color.green)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.white.opacity(0.4), lineWidth: 3)
                    )
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
            }
            .padding(.top, 10)

            Button {
                audioService.playButtonSound()
                vm.leaveLobby()
            } label: {
                Text("LEAVE")
                    .font(.kenneyFuture(size: 24))
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }

            Spacer().frame(height: 40)
        }
    }
}
