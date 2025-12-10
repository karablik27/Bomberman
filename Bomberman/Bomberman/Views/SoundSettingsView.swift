//
//  SoundSettingsView.swift
//  Bomberman
//
//  Created by Sergey on 10.12.2025.
//

import SwiftUI

struct SoundSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var audioService: AudioService
    
    init() {
        self._audioService = ObservedObject(wrappedValue: DIContainer.shared.audioService as! AudioService)
    }
    
    var body: some View {
        ZStack {
            Color.bombermanBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
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
                
                Text("Настройки звука")
                    .font(.kenneyFuture(size: 32))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, x: 2, y: 2)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                
                // Контейнер с настройками
                VStack(spacing: 30) {
                    // Переключатели Музыка и Эффекты
                    HStack(spacing: 30) {
                        // Музыка
                        VStack(spacing: 12) {
                            Text("Музыка")
                                .font(.kenneyFuture(size: 20))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                audioService.isMusicEnabled.toggle()
                            }) {
                                Text(audioService.isMusicEnabled ? "Вкл." : "Выкл.")
                                    .font(.kenneyFuture(size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(audioService.isMusicEnabled ? Color.bombermanGreen : Color.gray)
                                    )
                            }
                        }
                        
                        // Эффекты
                        VStack(spacing: 12) {
                            Text("Эффекты")
                                .font(.kenneyFuture(size: 20))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                audioService.isEffectsEnabled.toggle()
                            }) {
                                Text(audioService.isEffectsEnabled ? "Вкл." : "Выкл.")
                                    .font(.kenneyFuture(size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(audioService.isEffectsEnabled ? Color.bombermanGreen : Color.gray)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Громкость музыки
                    VStack(spacing: 12) {
                        Text("Громкость музыки")
                            .font(.kenneyFuture(size: 20))
                            .foregroundColor(.black)
                        
                        HStack {
                            Text("0")
                                .font(.kenneyFuture(size: 16))
                                .foregroundColor(.black)
                            
                            Slider(value: $audioService.musicVolume, in: 0...1)
                                .tint(Color.bombermanGreen)
                            
                            Text("100")
                                .font(.kenneyFuture(size: 16))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 30)
                    
                    // Громкость эффектов
                    VStack(spacing: 12) {
                        Text("Громкость эффектов")
                            .font(.kenneyFuture(size: 20))
                            .foregroundColor(.black)
                        
                        HStack {
                            Text("0")
                                .font(.kenneyFuture(size: 16))
                                .foregroundColor(.black)
                            
                            Slider(value: $audioService.effectsVolume, in: 0...1)
                                .tint(Color.bombermanGreen)
                            
                            Text("100")
                                .font(.kenneyFuture(size: 16))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.vertical, 30)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.bombermanDialogBackground)
                )
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SoundSettingsView()
}
