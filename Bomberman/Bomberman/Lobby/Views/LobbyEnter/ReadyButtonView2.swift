//
//  ReadyButtonView2.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 12.12.2025.
//

import SwiftUI

struct ReadyButtonView2: View {

    let title: String
    let color: Color
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.kenneyFuture(size: 26))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isEnabled ? color.opacity(0.85) : Color.gray.opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.9), lineWidth: 2)
                )
                .shadow(
                    color: isEnabled ? color.opacity(0.6) : .clear,
                    radius: 10,
                    y: 4
                )
        }
        .disabled(!isEnabled)
        .buttonStyle(PressedScaleButtonStyle())
    }
}
