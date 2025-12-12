//
//  GameSettings.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//

import Foundation

protocol GameSettingsProtocol: AnyObject {
    var showExplosionTrajectory: Bool { get set }
}

final class GameSettings: GameSettingsProtocol {
    private let explosionTrajectoryKey = "showExplosionTrajectory"

    var showExplosionTrajectory: Bool {
        get {
            UserDefaults.standard.object(forKey: explosionTrajectoryKey) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: explosionTrajectoryKey)
        }
    }
}
