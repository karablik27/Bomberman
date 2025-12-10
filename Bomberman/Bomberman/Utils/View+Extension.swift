//
//  View+PixelPanel.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

extension View {
    
    // MARK: - Deprecated simple panel
    func pixelPanel() -> some View {
        self
            .padding(12)
            .background(Color.white.opacity(0.10))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
            )
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.35), radius: 6, y: 4)
    }
    
    
    // MARK: - Поле ввода (красивый input frame)
    func gameInputFrame() -> some View {
        self
            .padding(10)
            .background(Color.black.opacity(0.35))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.8), lineWidth: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .padding(2)
            )
            .cornerRadius(10)
    }
    
    
    // MARK: - Стиль кнопки (рамка поверх уже залитой кнопки)
    func gameButtonFrame() -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.15), lineWidth: 2)
                    .padding(3)
            )
            .cornerRadius(14)
    }
    
    
    // MARK: - Карточка игрока (Glass-style card)
    func playerCard() -> some View {
        self
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .opacity(0.55)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1.4)
            )
            .shadow(color: .black.opacity(0.25), radius: 10, y: 5)
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    
    // MARK: - Гейм-кнопка (основной UI style)
    func gameButtonStyle(color: Color) -> some View {
        self
            .font(.kenneyFuture(size: 30))
            .foregroundColor(.white)
            .frame(width: 260, height: 70)
            .background(
                LinearGradient(
                    colors: [
                        color.opacity(0.90),
                        color.opacity(0.70)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.white.opacity(0.35), lineWidth: 2)
            )
            .shadow(color: color.opacity(0.45), radius: 14, y: 6)
            .cornerRadius(14)
    }
}
