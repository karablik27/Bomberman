//
//  AnimatedPlayerView.swift
//  Bomberman
//
//  Created by Alexandra Lazareva on 13.12.2025.
//

import SwiftUI

struct AnimatedPlayerView: View {
    let player: Player
    let isMe: Bool
    let tileSize: CGFloat
    let spriteProvider: GameViewModel

    @State private var animationFrame = 0
    @State private var animationTimer: Timer?

    private var frames: [String] {
        spriteProvider.animationFrames(for: player.id)
    }

    var body: some View {
        PlayerSpriteView(
            isMe: isMe,
            name: player.name,
            spriteName: frames[safe: animationFrame] ?? frames.first!
        )
        .frame(width: tileSize, height: tileSize)
        .offset(
            x: CGFloat(player.x) * tileSize,
            y: CGFloat(player.y) * tileSize
        )
        .animation(.easeOut(duration: 0.15), value: player.x)
        .animation(.easeOut(duration: 0.15), value: player.y)

        .onChange(of: player.x) { _ in
            startAnimation()
        }
        .onChange(of: player.y) { _ in
            startAnimation()
        }

        .onChange(of: frames) { _ in
            resetAnimation()
        }

        .onDisappear {
            stopAnimation()
        }
    }

    // MARK: - Animation

    private func startAnimation() {
        guard frames.count > 1 else { return }

        stopAnimation()
        animationFrame = 0

        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { _ in
            animationFrame = (animationFrame + 1) % frames.count
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            stopAnimation()
        }
    }

    private func resetAnimation() {
        stopAnimation()
        animationFrame = 0
    }

    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        animationFrame = 0
    }
}
