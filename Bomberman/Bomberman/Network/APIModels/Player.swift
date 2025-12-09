//
//  Player.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation

struct Player: Codable, Identifiable {
    let id: String
    let name: String
    let x: Int
    let y: Int
    let alive: Bool
    let ready: Bool
}
