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
            
            VStack(spacing: 6) {
                Text("LOBBY")
                    .font(.kenneyFuture(size: 46))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.9), radius: 10)
                
                Text("Players: \(vm.players.count)/4")
                    .font(.kenneyFuture(size: 20))
                    .foregroundColor(.white.opacity(0.75))
            }
            .padding(.top, 40)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    ForEach(vm.players) { player in
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
            .padding(.top, 10)
            
            Button {
                vm.leaveLobby()
            } label: {
                Text("LEAVE")
                    .font(.kenneyFuture(size: 22))
                    .foregroundColor(.red)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 24)
            }
            .gameButtonFrame()
            .padding(.top, 8)
            
            
            Spacer().frame(height: 40)
        }
    }
}
