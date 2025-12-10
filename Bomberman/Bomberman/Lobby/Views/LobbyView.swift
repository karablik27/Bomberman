//
//  LobbyView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI


struct LobbyView: View {
    @StateObject private var vm = LobbyViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var isInGame = false
    private let audioService = DIContainer.shared.audioService
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.bombermanBackground.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button {
                            audioService.playButtonSound()
                            vm.leaveLobby()
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
                    
                    if !vm.didJoin {
                        LobbyEnterView(vm: vm)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    } else {
                        LobbyPlayersView(vm: vm)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: String.self) { destination in
                if destination == "game" {
                    GameView(
                        onNavigateToRoot: {
                            isInGame = false
                            navigationPath = NavigationPath()
                            vm.leaveLobby()
                            dismiss()
                        },
                        onBackToLobby: {
                            isInGame = false
                            vm.resetState()
                        }
                    )
                    .onAppear {
                        isInGame = true
                    }
                }
            }
            .onChange(of: vm.gameStarted) { started in
                if started && !isInGame {
                    isInGame = true
                    navigationPath.append("game")
                }
            }
        }
    }
}
