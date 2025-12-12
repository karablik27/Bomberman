//
//  BlocksAnimator.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI
import Combine

final class BlocksAnimator: ObservableObject {

    @MainActor @Published var blocks: [Block] = []

    let blockImages = ["block_01", "block_02", "block_03", "block_04"]

    var spawnTask: Task<Void, Never>?
    var updateTask: Task<Void, Never>?

    private let engine = Engine()

    func setScreenSize(_ size: CGSize) {
        Task.detached(priority: .utility) { [engine] in
            await engine.setScreenSize(size)
        }
    }

    func start() {
        stop()

        spawnTask = Task.detached(priority: .background) { [weak self, engine] in
            guard let self else { return }
            while !Task.isCancelled {
                await engine.spawnBlock(images: self.blockImages)
                try? await Task.sleep(for: .milliseconds(250))
            }
        }

        updateTask = Task.detached(priority: .userInitiated) { [weak self, engine] in
            guard let self else { return }
            while !Task.isCancelled {
                let snapshot = await engine.updateAndGetSnapshot()

                await MainActor.run {
                    self.blocks = snapshot
                }

                try? await Task.sleep(nanoseconds: 16_000_000)
            }
        }
    }

    func stop() {
        spawnTask?.cancel()
        updateTask?.cancel()
        spawnTask = nil
        updateTask = nil
    }

    func reset() {
        stop()
        Task.detached(priority: .utility) { [engine] in
            await engine.reset()
        }
        Task { @MainActor in
            blocks.removeAll()
        }
    }

    func explode(at point: CGPoint) {
        Task.detached(priority: .userInitiated) { [weak self, engine] in
            guard let self else { return }
            await engine.explode(at: point)

            let snapshot = await engine.snapshot()
            await MainActor.run {
                self.blocks = snapshot
            }
        }
    }
}
