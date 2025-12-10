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
        VStack(spacing: 40) {

            Text("ENTER NAME")
                .font(.kenneyFuture(size: 34))
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.9), radius: 6)

            TextField("NAME", text: $name)
                .font(.kenneyFuture(size: 24))
                .foregroundColor(.white)
                .frame(width: 260, height: 55)
                .gameInputFrame()
            

            Button {
                audioService.playSignLobbySound()
                vm.connectAndJoin(with: name)
            } label: {
                Text("JOIN LOBBY")
                    .font(.kenneyFuture(size: 30))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(width: 260)
                    .background(Color.bombermanRed)
            }
            .gameButtonFrame()
        }
        .padding(.top, 90)
    }
}

