//
//  LobbyView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct LobbyView: View {

    @StateObject private var vm = LobbyViewModel()
    @State private var name: String = ""
    @State private var didJoin = false
    @State private var navigateToGame = false
    private let audioService = DIContainer.shared.audioService
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bombermanBackground.ignoresSafeArea()

                VStack(spacing: 20) {
                
                HStack {
                    Button {
                        audioService.playButtonSound()
                        vm.leaveLobby()
                        didJoin = false
                        name = ""
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
                
                if !didJoin {
                    VStack(spacing: 25) {
                        Text("ENTER NAME")
                            .font(.kenneyFuture(size: 28))
                            .foregroundColor(.white)

                        TextField("Your nickname", text: $name)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .frame(maxWidth: 250)

                        Button {
                            audioService.playSignLobbySound()
                            vm.connectAndJoin(with: name)
                            didJoin = true
                        } label: {
                            Text("JOIN LOBBY")
                                .font(.kenneyFuture(size: 28))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                                .background(Color.bombermanRed)
                                .cornerRadius(14)
                        }
                    }
                    .padding(.top, 80)

                    Spacer()
                }
                else {
                    VStack(spacing: 8) {
                        Text("LOBBY")
                            .font(.kenneyFuture(size: 40))
                            .foregroundColor(.white)
                        
                        Text("Игроков: \(vm.players.count)/4")
                            .font(.kenneyFuture(size: 18))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 40)

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(vm.players) { player in
                                HStack(spacing: 12) {
                                    Image("PlayerIcon")
                                        .resizable()
                                        .renderingMode(.original)
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
                        didJoin = false
                        name = ""
                    } label: {
                        Text("LEAVE")
                            .font(.kenneyFuture(size: 22))
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    Spacer()
                        .frame(height: 40)
                }

                NavigationLink(
                    destination: GameView(),
                    isActive: $navigateToGame
                ) {
                    EmptyView()
                }
            }
            }
            .navigationBarHidden(true)
            .onChange(of: vm.gameStarted) { started in
                if started {
                    navigateToGame = true
                }
            }
        }
    }
}
