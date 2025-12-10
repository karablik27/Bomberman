//
//  BlocksAnimator.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI
import Combine

@MainActor
class BlocksAnimator: ObservableObject {
    @Published var blocks: [Block] = []

    let blockImages = ["block_01", "block_02", "block_03", "block_04"]

    var screenSize: CGSize = .zero
    var explodePhase = false
    var spawnTask: Task<Void, Never>?
    var updateTask: Task<Void, Never>?

    func spawnBlock() {
        guard !explodePhase, screenSize != .zero else { return }

        let size = CGFloat.random(in: 40...80)

        let block = Block(
            imageName: blockImages.randomElement()!,
            x: CGFloat.random(in: 0...screenSize.width),
            y: -150,
            size: size,
            rotation: Double.random(in: 0...360),
            velocityY: CGFloat.random(in: 2...6),
            velocityX: CGFloat.random(in: -1.5...1.5),
            rotationSpeed: Double.random(in: -2...2)
        )

        blocks.append(block)
    }
    
    func stop() {
        spawnTask?.cancel()
        updateTask?.cancel()
        spawnTask = nil
        updateTask = nil
    }

    func update() {
        guard screenSize != .zero else { return }

        for i in blocks.indices {
            if blocks[i].isFrozen { continue }
            blocks[i].y += blocks[i].velocityY
            blocks[i].x += blocks[i].velocityX
            blocks[i].rotation += blocks[i].rotationSpeed


            blocks[i].velocityY += 0.25

            let bottom = screenSize.height - blocks[i].size

            if blocks[i].y >= bottom {
                
                blocks[i].y = bottom
                blocks[i].velocityY = -blocks[i].velocityY * 0.30
                blocks[i].velocityX *= 0.92

                if abs(blocks[i].velocityY) < 0.5 {
                    blocks[i].velocityY = 0
                }
            }

            for j in blocks.indices where j != i {
                let a = blocks[i]
                let b = blocks[j]

                let closeX = abs(a.x - b.x) < (a.size + b.size) * 0.55

                let isAbove = a.y < b.y
                let verticalTouch = (a.y + a.size) >= b.y && (a.y + a.size) <= b.y + 18

                if closeX && isAbove && verticalTouch {

                    blocks[i].y = b.y - a.size

                    let leftFree = isSpaceFree(x: a.x - a.size*0.8, y: a.y + a.size)
                    let rightFree = isSpaceFree(x: a.x + a.size*0.8, y: a.y + a.size)

                    if leftFree {
                        blocks[i].velocityX = -3
                        blocks[i].velocityY = 2
                    }
                    else if rightFree {
                        blocks[i].velocityX = 3
                        blocks[i].velocityY = 2
                    }
                    else {
                        blocks[i].velocityY = -abs(blocks[i].velocityY) * 0.25
                        if abs(blocks[i].velocityY) < 0.8 {
                            blocks[i].velocityY = 0
                        }
                    }
                }
            }

            blocks[i].x = max(blocks[i].size / 2,
                              min(screenSize.width - blocks[i].size / 2,
                                  blocks[i].x))

            let underLeft = isSpaceFree(
                x: blocks[i].x - blocks[i].size * 0.55,
                y: blocks[i].y + blocks[i].size * 0.7
            )

            let underRight = isSpaceFree(
                x: blocks[i].x + blocks[i].size * 0.55,
                y: blocks[i].y + blocks[i].size * 0.7
            )

            if blocks[i].velocityY == 0 {

                if underLeft {
                    blocks[i].velocityX -= 0.45
                    blocks[i].velocityY = 0.8
                }
                else if underRight {
                    blocks[i].velocityX += 0.45
                    blocks[i].velocityY = 0.8
                }
            }

            if blocks[i].velocityY == 0 &&
               abs(blocks[i].velocityX) < 0.05 &&
               hasSupport(blocks[i]) {

                blocks[i].isFrozen = true
                blocks[i].velocityX = 0
                blocks[i].velocityY = 0
                blocks[i].rotationSpeed = 0
            }
            
            for j in blocks.indices where j != i {
                resolveOverlap(i, j)
            }
        }
        blocks.removeAll { block in
            block.x < -300 || block.x > screenSize.width + 300 ||
            block.y < -300 || block.y > screenSize.height + 300
        }
    }

    private func resolveOverlap(_ i: Int, _ j: Int) {
        let ax = blocks[i].x
        let ay = blocks[i].y
        let bx = blocks[j].x
        let by = blocks[j].y

        let halfA = blocks[i].size / 2
        let halfB = blocks[j].size / 2

        let dx = ax - bx
        let dy = ay - by

        let minDistX = halfA + halfB
        let minDistY = halfA + halfB

        if abs(dx) < minDistX && abs(dy) < minDistY {

            let overlapX = minDistX - abs(dx)
            let overlapY = minDistY - abs(dy)

            if overlapX < 0.5 && overlapY < 0.5 {
                freezeIfStable(i)
                freezeIfStable(j)
                return
            }

            if overlapX < overlapY {
                let push = overlapX * 0.52
                blocks[i].x += dx > 0 ? push : -push
                blocks[j].x -= dx > 0 ? push : -push

                blocks[i].velocityX *= 0.25
                blocks[j].velocityX *= 0.25
            } else {
                let push = overlapY * 0.52
                blocks[i].y += dy > 0 ? push : -push
                blocks[j].y -= dy > 0 ? push : -push

                blocks[i].velocityY *= 0.25
                blocks[j].velocityY *= 0.25
            }

            blocks[i].rotationSpeed *= 0.45
            blocks[j].rotationSpeed *= 0.45
        }
    }

    private func freezeIfStable(_ index: Int) {
        if abs(blocks[index].velocityX) < 0.05 &&
           abs(blocks[index].velocityY) < 0.05 {

            blocks[index].velocityX = 0
            blocks[index].velocityY = 0
            blocks[index].rotationSpeed = 0
            blocks[index].isFrozen = true
        }
    }

    private func hasSupport(_ block: Block) -> Bool {
        let bottom = screenSize.height - block.size

        if abs(block.y - bottom) < 1 {
            return true
        }

        for b in blocks where b.id != block.id {
            if abs((block.y + block.size) - b.y) < 2 &&
                abs(block.x - b.x) < max(block.size, b.size) * 0.6 {

                return true
            }
        }
        return false
    }

    
    private func isSpaceFree(x: CGFloat, y: CGFloat) -> Bool {
        for block in blocks {
            let dx = abs(block.x - x)
            let dy = abs(block.y - y)

            if dx < block.size * 0.6 && dy < block.size * 0.6 {
                return false
            }
        }
        return true
    }

    func explode(at point: CGPoint) {
        guard !blocks.isEmpty else { return }

        explodePhase = true

        for i in blocks.indices {
            blocks[i].isFrozen = false

            let dx = blocks[i].x - point.x
            let dy = blocks[i].y - point.y

            var dist = sqrt(dx*dx + dy*dy)
            if dist < 8 { dist = 8 }

            let nx = dx / dist
            let ny = dy / dist

            let basePower: CGFloat = CGFloat.random(in: 90...160)

            let turbulenceAngle = CGFloat.random(in: -0.35...0.35)
            let cosT = cos(turbulenceAngle)
            let sinT = sin(turbulenceAngle)

            let dirX = nx * cosT - ny * sinT
            let dirY = nx * sinT + ny * cosT

            blocks[i].velocityX = dirX * basePower
            blocks[i].velocityY = dirY * basePower

            blocks[i].rotationSpeed = Double.random(in: -20...20)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.explodePhase = false
        }
    }

}
