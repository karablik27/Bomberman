//
//  WebSocketServiceProtocol.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation
import Combine

protocol WebSocketServiceProtocol: AnyObject {
    var messagePublisher: AnyPublisher<String, Never> { get }
    var connectionStatePublisher: AnyPublisher<WebSocketConnectionState, Never> { get }

    func connect()
    func disconnect()
    func send(_ text: String)
}
