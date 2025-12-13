//
//  BombView.swift
//  Bomberman
//
//  Created by Alexandra Lazareva on 13.12.2025.
//

import SwiftUI

struct BombView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image("BombActive")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 0.3)
                        .repeatForever(autoreverses: true)
                ) {
                    scale = 1.15
                }
            }
    }
}
