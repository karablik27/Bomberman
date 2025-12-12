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
    let onChatTap: () -> Void
    let isChatVisible: Bool

    @State private var showLeaderboardScreen = false

    init(
        vm: LobbyViewModel,
        audioService: AudioServiceProtocol,
        leaderboardService: LeaderboardServiceProtocol,
        isChatVisible: Bool,
        onChatTap: @escaping () -> Void
    ) {
        self.vm = vm
        self.audioService = audioService
        self.leaderboardService = leaderboardService
        self.isChatVisible = isChatVisible
        self.onChatTap = onChatTap
    }


    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(spacing: 6) {
                    Text("LOBBY")
                        .font(.kenneyFuture(size: 46))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.9), radius: 10)
                }

                Spacer()
                
                HStack(spacing: 14) {

                    Button {
                        audioService.playButtonSound()
                        showLeaderboardScreen = true
                    } label: {
                        Image("leaderboard")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.yellow)
                    }
                    
                    Button {
                        audioService.playButtonSound()
                        onChatTap()
                    } label: {
                        Image("chat")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.yellow)
                    }

                    // будущие кнопки
                    /*
                    Button { } label: {
                        Image("skins")
                    }

                    Button { } label: {
                        Image("settings")
                    }
                    */
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.95))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.85), lineWidth: 2)
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)

            .padding(.top, 40)

            PlayersPanelView(players: vm.players)
                .padding(.horizontal, 24)
            
            if isChatVisible {
                LobbyChatView(vm: vm)
                    .padding(.horizontal, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer()

            ReadyButtonView(isReady: vm.isReady) {
                audioService.playReadySound()
                vm.toggleReady()
            }
            .padding(.horizontal, 40)
        }
        .navigationDestination(isPresented: $showLeaderboardScreen) {
            LeaderboardBackView(
                audioService: audioService,
                leaderboardService: leaderboardService
            )
        }
    }
}
