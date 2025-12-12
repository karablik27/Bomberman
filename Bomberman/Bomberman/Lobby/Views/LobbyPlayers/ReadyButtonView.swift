//
//  ReadyButtonView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 12.12.2025.
//

import SwiftUI

struct ReadyButtonView: View {

    let isReady: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(isReady ? "UNREADY" : "READY")
                .font(.kenneyFuture(size: 30))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isReady ? Color.red.opacity(0.85) : Color.green.opacity(0.85))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.9), lineWidth: 2)
                )
                .shadow(
                    color: (isReady ? Color.red : Color.green).opacity(0.6),
                    radius: 10,
                    y: 4
                )
        }
        .buttonStyle(PressedScaleButtonStyle())
    }
}

struct PressedScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
