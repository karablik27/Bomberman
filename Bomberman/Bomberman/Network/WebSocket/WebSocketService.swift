//
//  WebSocketService.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

import Foundation
import Combine

@MainActor
final class WebSocketService: WebSocketServiceProtocol, ObservableObject {

    private var socket: URLSessionWebSocketTask?
    private var listenTask: Task<Void, Never>?

    private let url: URL

    private let messageSubject = PassthroughSubject<String, Never>()
    private let connectionStateSubject = CurrentValueSubject<WebSocketConnectionState, Never>(.disconnected)

    var messagePublisher: AnyPublisher<String, Never> {
        messageSubject.eraseToAnyPublisher()
    }

    var connectionStatePublisher: AnyPublisher<WebSocketConnectionState, Never> {
        connectionStateSubject.eraseToAnyPublisher()
    }

    // MARK: - Init
    init(url: URL) {
        self.url = url
    }

    // MARK: - Connect
    func connect() {
        guard socket == nil else { return }

        connectionStateSubject.send(.connecting)

        let task = URLSession.shared.webSocketTask(with: url)
        socket = task
        task.resume()

        connectionStateSubject.send(.connected)

        startListening()
    }

    // MARK: - Disconnect
    func disconnect() {
        listenTask?.cancel()
        listenTask = nil

        socket?.cancel(with: .normalClosure, reason: nil)
        socket = nil

        connectionStateSubject.send(.disconnected)
    }

    // MARK: - Listening loop
    private func startListening() {
        listenTask = Task {
            guard let socket else { return }

            do {
                while !Task.isCancelled {
                    let result = try await socket.receive()

                    switch result {
                    case .string(let text):
                        messageSubject.send(text)
                    default:
                        break
                    }
                }
            } catch {
                connectionStateSubject.send(.error(error))
            }

            connectionStateSubject.send(.disconnected)
        }
    }

    // MARK: - Send
    func send(_ text: String) {
        Task {
            do {
                try await socket?.send(.string(text))
            } catch {
                connectionStateSubject.send(.error(error))
            }
        }
    }
}
