//
//  KenneyBlocksBackground.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct KenneyBlocksBackground: View {
    @StateObject private var animator = BlocksAnimator()
    @State private var didStart = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.bombermanBackground
                    .onTapGesture { location in
                        animator.explode(at: location)
                    }

                ForEach(animator.blocks) { block in
                    BlockView(block: block)
                }
            }
            .onChange(of: geo.size, initial: false) { oldSize, newSize in
                animator.screenSize = newSize

                if newSize.width > 0 && newSize.height > 0 && !didStart {
                    didStart = true
                    startPhysics()
                }
            }
            .onDisappear {
                animator.stop()
            }
        }
        .ignoresSafeArea()
    }

    func startPhysics() {
        animator.spawnTask = Task { @MainActor in
            while !Task.isCancelled {
                animator.spawnBlock()
                try? await Task.sleep(for: .milliseconds(250))
            }
        }

        animator.updateTask = Task { @MainActor in
            while !Task.isCancelled {
                animator.update()
                try? await Task.sleep(nanoseconds: 16_000_000)
            }
        }
    }
}
