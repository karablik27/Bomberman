//
//  ButtonSoundModifier.swift
//  Bomberman
//
//  Created by Sergey on 10.12.2025.
//

import SwiftUI

struct ButtonSoundModifier: ViewModifier {
    let soundType: ButtonSoundType
    let audioService: AudioServiceProtocol
    
    enum ButtonSoundType {
        case button
        case signLobby
        case ready
    }
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        switch soundType {
                        case .button:
                            audioService.playButtonSound()
                        case .signLobby:
                            audioService.playSignLobbySound()
                        case .ready:
                            audioService.playReadySound()
                        }
                    }
            )
    }
}

extension View {
    func withButtonSound(_ soundType: ButtonSoundModifier.ButtonSoundType, audioService: AudioServiceProtocol) -> some View {
        self.modifier(ButtonSoundModifier(soundType: soundType, audioService: audioService))
    }
}
