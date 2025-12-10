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
                Color.black.opacity(0.2)
                    .onTapGesture { location in
                        animator.explode(at: location)
                    }

                ForEach(animator.blocks) { block in
                    BlockView(block: block)
                }
            }
            .onChange(of: geo.size) { newSize in
                animator.screenSize = newSize
                if newSize.width > 0 && newSize.height > 0 && !didStart {
                    didStart = true
                    startPhysics()
                }
            }
        }
        .ignoresSafeArea()
    }

    func startPhysics() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            animator.spawnBlock()
        }
        
        Task {
            while true {
                animator.update()
                try? await Task.sleep(nanoseconds: 16_000_000)
            }
        }
    }
}

