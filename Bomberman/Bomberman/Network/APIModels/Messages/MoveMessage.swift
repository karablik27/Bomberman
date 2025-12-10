//
//  MoveMessage.swift
//  Bomberman
//
//  Created by Kashapov Amir on 10.12.2025.
//

struct MoveMessage: Codable {
    let type: String = "move"
    let dx: Int
    let dy: Int
    
    init(dx: Int, dy: Int) {
        self.dx = dx
        self.dy = dy
    }
}