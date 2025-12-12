//
//  AppConfig.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation

enum AppConfig {
    static let webSocketURLString = "ws://89.169.176.217:8765"

    static var webSocketURL: URL {
        URL(string: webSocketURLString)! // уберу форс анврап чуть позже
    }
}
