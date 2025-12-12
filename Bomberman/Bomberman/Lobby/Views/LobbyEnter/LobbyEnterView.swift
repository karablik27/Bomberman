//
//  LobbyEnterView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct LobbyEnterView: View {

    @ObservedObject var vm: LobbyViewModel
    private let audioService = DIContainer.shared.audioService

    @State private var name: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {

            Spacer()

            VStack(spacing: 20) {

                Text("ENTER NAME")
                    .font(.kenneyFuture(size: 28))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.9), radius: 6)

                TextField("NAME", text: $name)
                    .font(.kenneyFuture(size: 22))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.12))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
                    )
                    .focused($isFocused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)

                ReadyButtonView2(
                    title: "JOIN LOBBY",
                    color: .green,
                    isEnabled: !name.trimmingCharacters(in: .whitespaces).isEmpty
                ) {
                    audioService.playSignLobbySound()
                    vm.connectAndJoin(with: name)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.9), lineWidth: 2)
            )
            .padding(.horizontal, 32)
            .padding(.top, -60)
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
        }
    }
}
