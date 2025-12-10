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
    }
}
