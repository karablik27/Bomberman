//
//  View+PixelPanel.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

extension View {
    func pixelPanel() -> some View {
        self
            .padding(12)
            .background(Color.white.opacity(0.12))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.25), lineWidth: 2)
            )
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 4)
    }
}
