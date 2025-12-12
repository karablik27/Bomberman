//
//  MenuGameView.swift
//  Bomberman
//
//  Created by Верховный Маг on 13.12.2025.
//

import SwiftUI

struct MenuGameView: View {

    @StateObject private var vm = MenuGameViewModel()
    @State private var smoothX: CGFloat = 0
    @State private var smoothY: CGFloat = 0

    let tileSize: CGFloat = 32

    private var currentPlayerSprite: String {
        let frames = MenuPlayerAnimation.frames[vm.player.direction]!
        return frames[min(vm.player.animationFrame, frames.count - 1)]
    }

    var body: some View {
        GeometryReader { geo in

            // Сколько тайлов нужно отрисовать вокруг экрана
            let tilesX = Int(geo.size.width / tileSize) + 4
            let tilesY = Int(geo.size.height / tileSize) + 4

            let targetX = CGFloat(vm.player.x)
            let targetY = CGFloat(vm.player.y)

            ZStack {

                // 🔲 БЕСКОНЕЧНАЯ КАРТА (без анимаций)
                ZStack {
                    ForEach(-tilesY/2...tilesY/2, id: \.self) { dy in
                        ForEach(-tilesX/2...tilesX/2, id: \.self) { dx in

                            let tileX = Int(smoothX) + dx
                            let tileY = Int(smoothY) + dy
                            let tile = MenuMapGenerator.tile(at: tileX, y: tileY)

                            tileView(tile)
                                .frame(width: tileSize, height: tileSize)
                                .position(
                                    x: geo.size.width / 2
                                        + CGFloat(dx) * tileSize
                                        - (smoothX.truncatingRemainder(dividingBy: 1) * tileSize),

                                    y: geo.size.height / 2
                                        + CGFloat(dy) * tileSize
                                        - (smoothY.truncatingRemainder(dividingBy: 1) * tileSize)
                                )
                        }
                    }
                }
                .transaction { tx in
                    tx.animation = nil   // ⛔️ НИКАКИХ анимаций тайлов
                }

                // 🧍 ИГРОК (всегда по центру)
                Image(currentPlayerSprite)
                    .resizable()
                    .frame(width: tileSize, height: tileSize)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )

                // 💣 БОМБЫ
                ForEach(vm.bombs.indices, id: \.self) { i in
                    let dx = CGFloat(vm.bombs[i].x) - smoothX
                    let dy = CGFloat(vm.bombs[i].y) - smoothY

                    Image("BombActive")
                        .resizable()
                        .frame(width: tileSize, height: tileSize)
                        .position(
                            x: geo.size.width / 2 + dx * tileSize,
                            y: geo.size.height / 2 + dy * tileSize
                        )
                }

                // 💥 ВЗРЫВЫ
                ForEach(vm.explosions.indices, id: \.self) { i in
                    let dx = CGFloat(vm.explosions[i].x) - smoothX
                    let dy = CGFloat(vm.explosions[i].y) - smoothY

                    Image("Fireball")
                        .resizable()
                        .frame(width: tileSize, height: tileSize)
                        .position(
                            x: geo.size.width / 2 + dx * tileSize,
                            y: geo.size.height / 2 + dy * tileSize
                        )
                }
            }
            .onAppear {
                // стартовая позиция камеры
                smoothX = targetX
                smoothY = targetY
            }
            .onChange(of: vm.player.x) { _, newX in
                withAnimation(.easeOut(duration: 0.25)) {
                    smoothX = CGFloat(newX)
                }
            }
            .onChange(of: vm.player.y) { _, newY in
                withAnimation(.easeOut(duration: 0.25)) {
                    smoothY = CGFloat(newY)
                }
            }
        }
        .clipped()
    }

    // MARK: - Tile view

    @ViewBuilder
    private func tileView(_ tile: MenuTile) -> some View {
        switch tile {
        case .wall:
            Image("WallTile").resizable()
        case .brick:
            Image("BrickTile").resizable()
        case .floor:
            Image("FloorTile").resizable()
        }
    }
}
