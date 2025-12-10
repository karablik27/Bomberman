//
//  LobbyEnterView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct LobbyEnterView: View {

    private let audioService = DIContainer.shared.audioService
    @ObservedObject var vm: LobbyViewModel
    @State private var name: String = ""

    var body: some View {
        VStack(spacing: 35) {

            Text("ENTER NAME")
                .font(.kenneyFuture(size: 32))
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.7), radius: 4)

            TextField("", text: $name)
                .font(.kenneyFuture(size: 22))
                .padding()
                .background(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white.opacity(0.3), lineWidth: 2)
                )
                .foregroundColor(.white)
                .frame(width: 260)

            Button {
                audioService.playSignLobbySound()
                vm.connectAndJoin(with: name)
            } label: {
                Text("JOIN LOBBY")
                    .font(.kenneyFuture(size: 30))
                    .foregroundColor(.white)
                    .frame(width: 260, height: 70)
                    .background(Color.bombermanRed)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.white.opacity(0.4), lineWidth: 3)
                    )
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.6), radius: 8)
            }
        }
        .padding(.top, 80)
    }
}
