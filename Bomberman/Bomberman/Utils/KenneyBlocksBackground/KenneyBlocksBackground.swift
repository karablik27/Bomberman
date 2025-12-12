//
//  KenneyBlocksBackground.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct KenneyBlocksBackground: View {
    @StateObject private var animator = BlocksAnimator()

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
            .onAppear {
                animator.reset()
                animator.setScreenSize(geo.size)
                animator.start()
            }
            .onChange(of: geo.size) { _, newSize in
                animator.setScreenSize(newSize)
            }
            .onDisappear {
                animator.reset()
            }
        }
        .ignoresSafeArea()
    }
}
