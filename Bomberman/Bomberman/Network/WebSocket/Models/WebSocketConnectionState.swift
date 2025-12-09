//
//  WebSocketConnectionState.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation

enum WebSocketConnectionState {
    case disconnected
    case connecting
    case connected
    case error(Error)
}
