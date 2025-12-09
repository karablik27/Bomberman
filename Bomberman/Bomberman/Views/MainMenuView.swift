import SwiftUI

struct MainMenuView: View {
    @State private var showSettings = false
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            Color.bombermanBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        showSettings = true
                    }) {
                        Image("SettingsIcon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                Text("BOMBERMAN")
                    .font(.kenneyFuture(size: 60))
                    .foregroundColor(.white)
                
                Spacer()

                Button(action: {
                    print("Start game")
                }) {
                    HStack(spacing: 15) {
                        Image("PlayIcon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        
                        Text("PLAY")
                            .font(.kenneyFuture(size: 32))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.bombermanRed)
                    )
                }
                .scaleEffect(isPulsing ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing)
                .onAppear {
                    isPulsing = true
                }
                
                Spacer()
                    .frame(height: 100)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    MainMenuView()
}
