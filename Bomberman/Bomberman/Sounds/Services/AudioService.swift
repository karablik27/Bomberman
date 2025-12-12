//
//  AudioService.swift
//  Bomberman
//
//  Created by Sergey on 10.12.2025.
//

import AVFoundation
import Combine
import UIKit

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
    
    @Published var isUsingCustomMusic: Bool = false
    @Published var customMusicFileName: String?
    
    private var audioPlayer: AVAudioPlayer?
    private var effectsPlayer: AVAudioPlayer?
    private var cancellables = Set<AnyCancellable>()
    private var wasPlayingBeforeBackground = false
    
    private var customMusicBookmarkData: Data? {
        get {
            return UserDefaults.standard.data(forKey: "customMusicBookmark")
        }
        set {
            if let data = newValue {
                UserDefaults.standard.set(data, forKey: "customMusicBookmark")
            } else {
                UserDefaults.standard.removeObject(forKey: "customMusicBookmark")
            }
        }
    }
    
    init() {
        configureAudioSession()
        loadSettings()
        setupAppStateObservers()
    }
    
    private func setupAppStateObservers() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                Task { @MainActor in
                    self?.handleAppWillResignActive()
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                Task { @MainActor in
                    self?.handleAppDidBecomeActive()
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleAppWillResignActive() {
        wasPlayingBeforeBackground = audioPlayer?.isPlaying ?? false
        if wasPlayingBeforeBackground {
            pauseMusic()
        }
    }
    
    private func handleAppDidBecomeActive() {
        if wasPlayingBeforeBackground && isMusicEnabled {
            resumeMusic()
        }
        wasPlayingBeforeBackground = false
    }
    
    private func loadSettings() {
        isMusicEnabled = UserDefaults.standard.object(forKey: "isMusicEnabled") as? Bool ?? true
        isEffectsEnabled = UserDefaults.standard.object(forKey: "isEffectsEnabled") as? Bool ?? true
        musicVolume = UserDefaults.standard.object(forKey: "musicVolume") as? Float ?? 1.0
        effectsVolume = UserDefaults.standard.object(forKey: "effectsVolume") as? Float ?? 1.0
        isUsingCustomMusic = UserDefaults.standard.bool(forKey: "isUsingCustomMusic")
        customMusicFileName = UserDefaults.standard.string(forKey: "customMusicFileName")
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудио сессии: \(error)")
        }
    }
    
    private func getLobbyMusicURL() -> URL? {
        if isUsingCustomMusic {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let possibleExtensions = ["mp3", "m4a", "aac", "wav"]
            
            for ext in possibleExtensions {
                let destinationURL = documentsPath.appendingPathComponent("customLobbyMusic.\(ext)")
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    return destinationURL
                }
            }
            
            print("Кастомный файл не найден, переключаемся на дефолтную музыку")
            isUsingCustomMusic = false
            customMusicFileName = nil
            UserDefaults.standard.set(false, forKey: "isUsingCustomMusic")
            UserDefaults.standard.removeObject(forKey: "customMusicFileName")
            UserDefaults.standard.removeObject(forKey: "customMusicBookmark")
        }
        return Bundle.main.url(forResource: "Lobby", withExtension: "mp3")
    }
    
    private func getGameMusicURL() -> URL? {
        return Bundle.main.url(forResource: "Game", withExtension: "mp3")
    }
    
    func playLobbyMusic() {
        guard isMusicEnabled else { return }
        
        guard let url = getLobbyMusicURL() else {
            print("Не удалось найти файл музыки лобби")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = musicVolume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Ошибка воспроизведения музыки лобби: \(error)")
        }
    }
    
    func playGameMusic() {
        guard isMusicEnabled else { return }
        
        guard let url = getGameMusicURL() else {
            print("Не удалось найти файл музыки игры")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = musicVolume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Ошибка воспроизведения музыки игры: \(error)")
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
            // Если плеер не создан, запускаем музыку лобби по умолчанию
            playLobbyMusic()
        } else {
            audioPlayer?.play()
        }
    }
    
    func setCustomMusic(url: URL) throws {
        // Получаем доступ к security-scoped resource
        guard url.startAccessingSecurityScopedResource() else {
            throw NSError(domain: "AudioService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить доступ к файлу"])
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        let fileName = url.deletingPathExtension().lastPathComponent
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("customLobbyMusic.\(url.pathExtension)")
        
        let possibleExtensions = ["mp3", "m4a", "aac", "wav"]
        for ext in possibleExtensions {
            let oldURL = documentsPath.appendingPathComponent("customLobbyMusic.\(ext)")
            try? FileManager.default.removeItem(at: oldURL)
        }
        
        // Копируем новый файл
        try FileManager.default.copyItem(at: url, to: destinationURL)
        
        let bookmarkData = try url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
        customMusicBookmarkData = bookmarkData
        
        // Сохраняем состояние
        isUsingCustomMusic = true
        customMusicFileName = fileName
        UserDefaults.standard.set(true, forKey: "isUsingCustomMusic")
        UserDefaults.standard.set(fileName, forKey: "customMusicFileName")
        
        if isMusicEnabled {
            stopMusic()
            playLobbyMusic()
        }
    }
    
    func useDefaultMusic() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let possibleExtensions = ["mp3", "m4a", "aac", "wav"]
        for ext in possibleExtensions {
            let url = documentsPath.appendingPathComponent("customLobbyMusic.\(ext)")
            try? FileManager.default.removeItem(at: url)
        }
        
        customMusicBookmarkData = nil
        isUsingCustomMusic = false
        customMusicFileName = nil
        UserDefaults.standard.set(false, forKey: "isUsingCustomMusic")
        UserDefaults.standard.removeObject(forKey: "customMusicFileName")
        UserDefaults.standard.removeObject(forKey: "customMusicBookmark")
        
        if isMusicEnabled {
            stopMusic()
            playLobbyMusic()
        }
    }
    
    // MARK: - Звуки эффектов
    private func playSoundEffect(filename: String) {
        guard isEffectsEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Не удалось найти файл \(filename).mp3")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = effectsVolume
            player.play()
            effectsPlayer = player
        } catch {
            print("Ошибка воспроизведения звукового эффекта: \(error)")
        }
    }
    
    func playButtonSound() {
        playSoundEffect(filename: "Buttons")
    }
    
    func playSignLobbySound() {
        playSoundEffect(filename: "SignLobby")
    }
    
    func playReadySound() {
        playSoundEffect(filename: "Ready")
    }
    
    func playExplosionSound() {
        playSoundEffect(filename: "Explosion")
    }
}
