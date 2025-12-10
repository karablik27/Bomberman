//
//  AudioService.swift
//  Bomberman
//
//  Created by Sergey on 10.12.2025.
//

import AVFoundation
import Combine

@MainActor
final class AudioService: AudioServiceProtocol, ObservableObject {
    
    @Published var isMusicEnabled: Bool = true {
        didSet {
            if isMusicEnabled {
                resumeMusic()
            } else {
                pauseMusic()
            }
            UserDefaults.standard.set(isMusicEnabled, forKey: "isMusicEnabled")
        }
    }
    
    @Published var isEffectsEnabled: Bool = true {
        didSet {
            UserDefaults.standard.set(isEffectsEnabled, forKey: "isEffectsEnabled")
        }
    }
    
    @Published var musicVolume: Float = 1.0 {
        didSet {
            audioPlayer?.volume = musicVolume
            UserDefaults.standard.set(musicVolume, forKey: "musicVolume")
        }
    }
    
    @Published var effectsVolume: Float = 1.0 {
        didSet {
            UserDefaults.standard.set(effectsVolume, forKey: "effectsVolume")
        }
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        configureAudioSession()
        loadSettings()
    }
    
    private func loadSettings() {
        isMusicEnabled = UserDefaults.standard.object(forKey: "isMusicEnabled") as? Bool ?? true
        isEffectsEnabled = UserDefaults.standard.object(forKey: "isEffectsEnabled") as? Bool ?? true
        musicVolume = UserDefaults.standard.object(forKey: "musicVolume") as? Float ?? 1.0
        effectsVolume = UserDefaults.standard.object(forKey: "effectsVolume") as? Float ?? 1.0
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудио сессии: \(error)")
        }
    }
    
    func playLobbyMusic() {
        guard isMusicEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: "Lobby", withExtension: "mp3") else {
            print("Не удалось найти файл Lobby.mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = musicVolume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Ошибка воспроизведения музыки: \(error)")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    func pauseMusic() {
        audioPlayer?.pause()
    }
    
    func resumeMusic() {
        if audioPlayer == nil {
            playLobbyMusic()
        } else {
            audioPlayer?.play()
        }
    }
}
