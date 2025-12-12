//
//  GameSettings.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//

import Foundation

class GameSettings {
    static let shared = GameSettings()
    
    private let explosionTrajectoryKey = "showExplosionTrajectory"
    
    private init() {}
    
    var showExplosionTrajectory: Bool {
        get {
            UserDefaults.standard.object(forKey: explosionTrajectoryKey) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: explosionTrajectoryKey)
        }
    }
}
