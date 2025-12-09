//
//  DIContainer.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation

final class DIContainer {
    public static let shared = DIContainer()

    let webSocketService: WebSocketServiceProtocol

    private init() {
        self.webSocketService = WebSocketService(url: AppConfig.webSocketURL)
    }
}
