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
    
    private var customMusicURL: URL? {
        get {
            guard let urlString = UserDefaults.standard.string(forKey: "customMusicURL") else { return nil }
            return URL(string: urlString)
        }
        set {
            if let url = newValue {
                UserDefaults.standard.set(url.absoluteString, forKey: "customMusicURL")
            } else {
                UserDefaults.standard.removeObject(forKey: "customMusicURL")
            }
        }
    }
    
    init() {
        configureAudioSession()
        loadSettings()
        setupAppStateObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupAppStateObservers() {
        // Подписываемся на уведомления о смене состояния приложения
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
        // Сохраняем состояние воспроизведения перед уходом в фон
        wasPlayingBeforeBackground = audioPlayer?.isPlaying ?? false
        if wasPlayingBeforeBackground {
            pauseMusic()
        }
    }
    
    private func handleAppDidBecomeActive() {
        // Возобновляем музыку, если она играла до ухода в фон и включена
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
    
    private func getMusicURL() -> URL? {
        if isUsingCustomMusic, let customURL = customMusicURL {
            // Проверяем, что файл существует
            if FileManager.default.fileExists(atPath: customURL.path) {
                return customURL
            } else {
                // Если файл не найден, сбрасываем на дефолтную
                print("Кастомный файл не найден, переключаемся на дефолтную музыку")
                isUsingCustomMusic = false
                customMusicFileName = nil
                UserDefaults.standard.set(false, forKey: "isUsingCustomMusic")
                UserDefaults.standard.removeObject(forKey: "customMusicFileName")
            }
        }
        return Bundle.main.url(forResource: "Lobby", withExtension: "mp3")
    }
    
    func playLobbyMusic() {
        guard isMusicEnabled else { return }
        
        guard let url = getMusicURL() else {
            print("Не удалось найти файл музыки")
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
    
    func setCustomMusic(url: URL) throws {
        // Получаем имя файла без расширения для отображения
        let fileName = url.deletingPathExtension().lastPathComponent
        
        // Копируем файл в Documents директорию
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("customLobbyMusic.\(url.pathExtension)")
        
        // Удаляем старый файл, если существует
        try? FileManager.default.removeItem(at: destinationURL)
        
        // Копируем новый файл
        try FileManager.default.copyItem(at: url, to: destinationURL)
        
        // Сохраняем путь к кастомной музыке и имя файла
        customMusicURL = destinationURL
        isUsingCustomMusic = true
        customMusicFileName = fileName
        UserDefaults.standard.set(true, forKey: "isUsingCustomMusic")
        UserDefaults.standard.set(fileName, forKey: "customMusicFileName")
        
        // Перезапускаем музыку, если она играет
        if isMusicEnabled {
            stopMusic()
            playLobbyMusic()
        }
    }
    
    func useDefaultMusic() {
        // Удаляем кастомную музыку
        if let customURL = customMusicURL {
            try? FileManager.default.removeItem(at: customURL)
        }
        
        customMusicURL = nil
        isUsingCustomMusic = false
        customMusicFileName = nil
        UserDefaults.standard.set(false, forKey: "isUsingCustomMusic")
        UserDefaults.standard.removeObject(forKey: "customMusicFileName")
        
        // Перезапускаем музыку, если она играет
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
}
