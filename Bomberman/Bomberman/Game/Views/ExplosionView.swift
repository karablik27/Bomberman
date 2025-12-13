//
//  ExplosionView.swift
//  Bomberman
//
//  Created by Alexandra Lazareva on 13.12.2025.
//

import SwiftUI

struct ExplosionView: View {
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Image("Fireball")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.easeOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                ) {
                    opacity = 0.6
                }
            }
    }
}
