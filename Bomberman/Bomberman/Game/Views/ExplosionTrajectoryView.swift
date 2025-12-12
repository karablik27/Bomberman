//
//  ExplosionTrajectoryView.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//

import SwiftUI

struct ExplosionTrajectoryView: View {
    let bombX: Int
    let bombY: Int
    let map: [[String]]
    let tileSize: CGFloat
    
    private let blastRadius = 2
    
    var body: some View {
        ZStack {
            // Подсветка центральной клетки
            highlightCell(x: bombX, y: bombY)
            
            // Подсветка в радиусе взрыва
            highlightDirection(dx: 0, dy: 1) // Вниз
            highlightDirection(dx: 0, dy: -1) // Вверх
            highlightDirection(dx: 1, dy: 0) // Вправо
            highlightDirection(dx: -1, dy: 0) // Влево
        }
    }
    
    private func highlightDirection(dx: Int, dy: Int) -> some View {
        ZStack {
            ForEach(1...blastRadius, id: \.self) { distance in
                let x = bombX + dx * distance
                let y = bombY + dy * distance
                
                if isValidCell(x: x, y: y) {
                    highlightCell(x: x, y: y)
                }
            }
        }
    }
    
    private func highlightCell(x: Int, y: Int) -> some View {
        Rectangle()
            .fill(Color.red.opacity(0.3))
            .frame(width: tileSize, height: tileSize)
            .offset(
                x: CGFloat(x) * tileSize,
                y: CGFloat(y) * tileSize
            )
            .overlay(
                Rectangle()
                    .stroke(Color.red.opacity(0.6), lineWidth: 2)
                    .frame(width: tileSize, height: tileSize)
            )
    }
    
    private func isValidCell(x: Int, y: Int) -> Bool {
        guard y >= 0 && y < map.count else { return false }
        guard x >= 0 && x < map[y].count else { return false }
        
        let tile = map[y][x]
        
        if tile == "#" {
            return false
        }
        
        return true
    }
}
