//
//  MenuGameViewModel.swift
//  Bomberman
//
//  Created by Верховный Маг on 13.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class MenuGameViewModel: ObservableObject {

    @Published var player: MenuPlayer
    @Published var bombs: [(x: Int, y: Int)] = []
    @Published var explosions: [(x: Int, y: Int)] = []

    // MARK: - Timing
    private var simulationTimer: Timer?
    private var lastBombTime: Date = .distantPast

    private let bombCooldown: TimeInterval = 2.5
    private let bombFuseTime: TimeInterval = 1.2

    init() {
        player = MenuPlayer(x: 0, y: 0)
        startSimulation()
    }

    deinit {
        simulationTimer?.invalidate()
    }

    // MARK: - Simulation

    func startSimulation() {
        simulationTimer?.invalidate()

        simulationTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { [weak self] _ in
            guard let self else { return }

            self.randomMove()

            if Int.random(in: 0...4) == 0 {
                self.placeBombIfPossible()
            }
        }
    }

    // MARK: - Movement

    private func randomMove() {
        let moves: [(dx: Int, dy: Int, dir: MenuDirection)] = [
            (0, -1, .up),
            (0,  1, .down),
            (-1, 0, .left),
            (1,  0, .right)
        ]

        guard let move = moves.randomElement() else { return }

        let nx = player.x + move.dx
        let ny = player.y + move.dy

        // 🔥 Проверка через бесконечную карту
        let tile = MenuMapGenerator.tile(at: nx, y: ny)
        guard tile == .floor else { return }

        player.x = nx
        player.y = ny
        player.direction = move.dir

        animateStep()
    }

    private func animateStep() {
        player.animationFrame = 0

        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            self.player.animationFrame += 1
            if self.player.animationFrame >= 3 {
                self.player.animationFrame = 0
                timer.invalidate()
            }
        }
    }

    // MARK: - Bombs

    private func placeBombIfPossible() {
        let now = Date()

        guard bombs.isEmpty else { return }
        guard now.timeIntervalSince(lastBombTime) > bombCooldown else { return }

        lastBombTime = now
        bombs = [(player.x, player.y)]

        DispatchQueue.main.asyncAfter(deadline: .now() + bombFuseTime) {
            self.explode(at: self.player.x, self.player.y)
        }
    }

    private func explode(at x: Int, _ y: Int) {
        explosions = [(x, y)]

        // Только визуальный эффект — карту НЕ меняем
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.explosions.removeAll()
            self.bombs.removeAll()
        }
    }
}
