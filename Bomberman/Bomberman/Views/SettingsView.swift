import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showSoundSettings = false
    @State private var showMusicSettings = false
    private let audioService = DIContainer.shared.audioService
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bombermanBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Настройки")
                        .font(.kenneyFuture(size: 40))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            audioService.playButtonSound()
                            showSoundSettings = true
                        }) {
                            SettingRow(title: "Звуки", icon: "AudioIcon")
                        }
                        
                        Button(action: {
                            audioService.playButtonSound()
                            showMusicSettings = true
                        }) {
                            SettingRow(title: "Музыка", icon: "MusicIcon")
                        }
                        
                        SettingRow(title: "Информация", icon: "InformationIcon")
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    Button(action: {
                        audioService.playButtonSound()
                        dismiss()
                    }) {
                        Text("Закрыть")
                            .font(.kenneyFuture(size: 24))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.bombermanRed)
                            )
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSoundSettings) {
                SoundSettingsView()
            }
            .sheet(isPresented: $showMusicSettings) {
                MusicSettingsView()
            }
        }
    }
}

struct SettingRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .frame(width: 40)
            
            Text(title)
                .font(.kenneyFuture(size: 22))
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.1))
        )
    }
}

#Preview {
    SettingsView()
}
