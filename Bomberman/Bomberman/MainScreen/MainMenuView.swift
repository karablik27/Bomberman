import SwiftUI

struct MainMenuView: View {

    @State private var showSettings = false
    @State private var showLobby = false
    @State private var showOnboarding = false
    @State private var isPulsing = false

    private let audioService = DIContainer.shared.audioService

    var body: some View {
        ZStack {
            Color.bombermanBackground
                .ignoresSafeArea()

            MenuGameView()
                .mask(
                    RoundedRectangle(cornerRadius: 18)
                        .frame(height: UIScreen.main.bounds.height * 0.33)
                )


            VStack {
                HStack {
                    Spacer()
                    Button {
                        audioService.playButtonSound()
                        showSettings = true
                    } label: {
                        Image("SettingsIcon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .padding()
                    }
                }
                .padding(.top, 20)

                Spacer()

                Text("BOMBERMAN")
                    .font(.kenneyFuture(size: 52))
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.black.opacity(0.45))
                    )
                    .padding(.top, -240)

                Spacer()

                Button {
                    audioService.playButtonSound()
                    showLobby = true
                } label: {
                    HStack(spacing: 14) {
                        Image("PlayIcon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)

                        Text("PLAY")
                            .font(.kenneyFuture(size: 32))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 54)
                    .padding(.vertical, 22)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.bombermanRed)
                            .shadow(color: .red.opacity(0.7), radius: 18)
                    )
                }
                .scaleEffect(isPulsing ? 1.06 : 1)
                .animation(
                    .easeInOut(duration: 1.6).repeatForever(autoreverses: true),
                    value: isPulsing
                )
                .onAppear { isPulsing = true }

                Spacer()
                    .frame(height: 90)
            }
        }
        .fullScreenCover(isPresented: $showLobby) {
            LobbyView()
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
        }
        .onAppear {
            if !OnboardingService.shared.hasSeenOnboarding {
                showOnboarding = true
            }
            audioService.playLobbyMusic()
        }
    }
}

#Preview {
    MainMenuView()
}
