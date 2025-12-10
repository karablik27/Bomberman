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
    var isUsingCustomMusic: Bool { get }
    var customMusicFileName: String? { get }
    
    func playLobbyMusic()
    func playGameMusic()
    func stopMusic()
    func pauseMusic()
    func resumeMusic()
    
    func playButtonSound()
    func playSignLobbySound()
    func playReadySound()
    func playExplosionSound()
    
    func setCustomMusic(url: URL) throws
    func useDefaultMusic()
}
