//
//  MusicSettingsView.swift
//  Bomberman
//
//  Created by Sergey on 10.12.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct MusicSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var audioService: AudioService
    @State private var showDocumentPicker = false
    @State private var selectedFileURL: URL?
    @State private var showError = false
    @State private var errorMessage = ""
    
    init() {
        self._audioService = ObservedObject(wrappedValue: DIContainer.shared.audioService as! AudioService)
    }
    
    var body: some View {
        ZStack {
            Color.bombermanBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок и кнопка закрытия
                HStack {
                    Spacer()
                    Button(action: {
                        audioService.playButtonSound()
                        dismiss()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.bombermanRed)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Text("Настройки музыки")
                    .font(.kenneyFuture(size: 32))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, x: 2, y: 2)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                
                // Контейнер с настройками
                VStack(spacing: 25) {
                    // Информация о текущей музыке
                    VStack(spacing: 12) {
                        Text("Текущая музыка:")
                            .font(.kenneyFuture(size: 20))
                            .foregroundColor(.black)
                        
                        if let fileName = audioService.customMusicFileName, audioService.isUsingCustomMusic {
                            ScrollView(.horizontal, showsIndicators: false) {
                                Text(fileName)
                                    .font(.kenneyFuture(size: 18))
                                    .foregroundColor(.black.opacity(0.7))
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text("Музыка по умолчанию")
                                .font(.kenneyFuture(size: 18))
                                .foregroundColor(.black.opacity(0.7))
                        }
                    }
                    
                    Divider()
                        .background(Color.black.opacity(0.3))
                    
                    // Выбор музыки
                    VStack(spacing: 15) {
                        Button(action: {
                            audioService.playButtonSound()
                            audioService.useDefaultMusic()
                        }) {
                            HStack {
                                Image(systemName: "music.note")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                
                                Text("Использовать музыку по умолчанию")
                                    .font(.kenneyFuture(size: 18))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if !audioService.isUsingCustomMusic {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.bombermanGreen)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.bombermanRed)
                            )
                        }
                        
                        Button(action: {
                            audioService.playButtonSound()
                            showDocumentPicker = true
                        }) {
                            HStack {
                                Image(systemName: "folder")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                
                                Text("Загрузить свою музыку")
                                    .font(.kenneyFuture(size: 18))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if audioService.isUsingCustomMusic {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                            )
                        }
                    }
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.bombermanDialogBackground)
                )
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(
                selectedURL: $selectedFileURL,
                allowedContentTypes: [.audio, .mp3, .wav]
            )
        }
        .onChange(of: selectedFileURL) { newValue in
            if let url = newValue {
                handleMusicSelection(url: url)
            }
        }
        .alert("Ошибка", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func handleMusicSelection(url: URL) {
        do {
            try audioService.setCustomMusic(url: url)
        } catch {
            errorMessage = "Не удалось загрузить музыку: \(error.localizedDescription)"
            showError = true
        }
    }
}

#Preview {
    MusicSettingsView()
}
