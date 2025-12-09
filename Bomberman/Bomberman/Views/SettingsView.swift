import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bombermanBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("SETTINGS")
                        .font(.kenneyFuture(size: 40))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        SettingRow(title: "AUDIO", icon: "AudioIcon")
                        SettingRow(title: "MUSIC", icon: "MusicIcon")
                        SettingRow(title: "INFORMATION", icon: "InformationIcon")
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("CLOSE")
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