//
//  AudioServiceProtocol.swift
//  Bomberman
//
//  Created by Sergey on 10.12.2025.
//

import Foundation

protocol AudioServiceProtocol: AnyObject {
    
    var isMusicEnabled: Bool { get set }
    var isEffectsEnabled: Bool { get set }
    var musicVolume: Float { get set }
    var effectsVolume: Float { get set }
    
    func playLobbyMusic()
    func stopMusic()
    func pauseMusic()
    func resumeMusic()
}
