//
//  GameView.swift
//  Bomberman
//
//  Created by Kashapov Amir on 10.12.2025.
//

import SwiftUI

struct GameView: View {
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @GestureState private var magnifyBy: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    @State private var showDeathOverlay = false
    @GestureState private var panTranslation: CGSize = .zero
    
    @StateObject private var vm = GameViewModel()
    @Environment(\.dismiss) private var dismiss
    
    private let audioService = DIContainer.shared.audioService
    
    var onLeaveToMainMenu: (() -> Void)?
    
    private let tileSize: CGFloat = 40
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.bombermanBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    topBar
                    
                    Spacer(minLength: 10)
                    
                    gameBoardWithPlayerCentering(viewportSize: CGSize(
                        width: geometry.size.width - 20,
                        height: geometry.size.height * 0.5
                    ))
                    .frame(height: geometry.size.height * 0.5)
                    
                    Spacer(minLength: 10)
                    
                    controlPad
                        .padding(.bottom, 30)
                }
                
                if !vm.isAlive && vm.isPlaying && showDeathOverlay {
                    defeatOverlay
                }

                if vm.isGameOver {
                    gameOverOverlay
                }
            }
        }
        .onChange(of: vm.isAlive) { alive in
            if !alive && vm.isPlaying {
                showDeathOverlay = true
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            audioService.playGameMusic()
        }
        .onDisappear {
            audioService.playLobbyMusic()
        }
    }
    
    private func gameBoardWithPlayerCentering(viewportSize: CGSize) -> some View {
        let mapHeight = vm.map.count
        let mapWidth = vm.map.first?.count ?? 0
        
        let boardWidth = CGFloat(mapWidth) * tileSize
        let boardHeight = CGFloat(mapHeight) * tileSize
        
        var cameraX: CGFloat = boardWidth / 2
        var cameraY: CGFloat = boardHeight / 2
        
        if let myPlayer = vm.myPlayer, myPlayer.alive {
            cameraX = CGFloat(myPlayer.x) * tileSize + tileSize / 2
            cameraY = CGFloat(myPlayer.y) * tileSize + tileSize / 2
        }
        
        let currentScale = scale * magnifyBy
        
        // Вычисляем размеры карты с учетом зума
        let scaledBoardWidth = boardWidth * currentScale
        let scaledBoardHeight = boardHeight * currentScale
        
        // Проверяем, помещается ли карта на экран
        let fitsOnScreen = scaledBoardWidth <= viewportSize.width && scaledBoardHeight <= viewportSize.height
        
        var offsetX: CGFloat
        var offsetY: CGFloat
        
        if fitsOnScreen {
            // Карта помещается - показываем всю карту, центрируем
            offsetX = (viewportSize.width - scaledBoardWidth) / 2
            offsetY = (viewportSize.height - scaledBoardHeight) / 2
            
            // Сбрасываем панорамирование, если карта помещается
            if abs(panOffset.width) > 0.1 || abs(panOffset.height) > 0.1 {
                DispatchQueue.main.async {
                    panOffset = .zero
                }
            }
        } else {
            // Карта не помещается - используем панорамирование или центрирование на игроке
            let totalPanX = panOffset.width + panTranslation.width
            let totalPanY = panOffset.height + panTranslation.height
            
            // Вычисляем границы для панорамирования
            let maxPanX = (scaledBoardWidth - viewportSize.width) / 2
            let maxPanY = (scaledBoardHeight - viewportSize.height) / 2
            
            // Ограничиваем панорамирование границами
            let constrainedPanX = min(maxPanX, max(-maxPanX, totalPanX))
            let constrainedPanY = min(maxPanY, max(-maxPanY, totalPanY))
            
            // Используем панорамирование, если оно есть
            if abs(constrainedPanX) > 0.1 || abs(constrainedPanY) > 0.1 ||
               abs(panOffset.width) > 0.1 || abs(panOffset.height) > 0.1 {
                // Используем панорамирование
                offsetX = constrainedPanX - (boardWidth * currentScale / 2) + (viewportSize.width / 2)
                offsetY = constrainedPanY - (boardHeight * currentScale / 2) + (viewportSize.height / 2)
            } else {
                // Если панорамирования нет, центрируем на игроке
                offsetX = viewportSize.width / 2 - cameraX * currentScale
                offsetY = viewportSize.height / 2 - cameraY * currentScale
                
                // Ограничиваем границами карты
                if scaledBoardWidth > viewportSize.width {
                    let minOffsetX = viewportSize.width - scaledBoardWidth
                    let maxOffsetX: CGFloat = 0
                    offsetX = min(maxOffsetX, max(minOffsetX, offsetX))
                }
                
                if scaledBoardHeight > viewportSize.height {
                    let minOffsetY = viewportSize.height - scaledBoardHeight
                    let maxOffsetY: CGFloat = 0
                    offsetY = min(maxOffsetY, max(minOffsetY, offsetY))
                }
            }
        }
        
        return GeometryReader { geo in
            gameBoard
                .scaleEffect(currentScale)
                .position(
                    x: (boardWidth / 2 + offsetX) * currentScale + (viewportSize.width / 2) * (1 - currentScale),
                    y: (boardHeight / 2 + offsetY) * currentScale + (viewportSize.height / 2) * (1 - currentScale)
                )
                .animation(.easeOut(duration: 0.15), value: offsetX)
                .animation(.easeOut(duration: 0.15), value: offsetY)
                .simultaneousGesture(
                    MagnificationGesture()
                        .updating($magnifyBy) { currentState, gestureState, _ in
                            gestureState = currentState
                        }
                        .onEnded { value in
                            scale = min(max(scale * value, 0.5), 2.0)
                            lastScale = scale
                            
                            // Сбрасываем панорамирование если карта теперь помещается
                            let newScaledWidth = boardWidth * scale
                            let newScaledHeight = boardHeight * scale
                            if newScaledWidth <= viewportSize.width && newScaledHeight <= viewportSize.height {
                                panOffset = .zero
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 5)
                        .updating($panTranslation) { value, state, _ in
                            // Панорамирование работает только если карта не помещается
                            let scaledBoardWidth = boardWidth * (scale * magnifyBy)
                            let scaledBoardHeight = boardHeight * (scale * magnifyBy)
                            if scaledBoardWidth > viewportSize.width || scaledBoardHeight > viewportSize.height {
                                state = value.translation
                            }
                        }
                        .onEnded { value in
                            let scaledBoardWidth = boardWidth * scale
                            let scaledBoardHeight = boardHeight * scale
                            
                            // Панорамирование работает только если карта не помещается
                            if scaledBoardWidth > viewportSize.width || scaledBoardHeight > viewportSize.height {
                                panOffset.width += value.translation.width
                                panOffset.height += value.translation.height
                                
                                // Ограничиваем границы
                                let maxPanX = (scaledBoardWidth - viewportSize.width) / 2
                                let maxPanY = (scaledBoardHeight - viewportSize.height) / 2
                                
                                panOffset.width = min(maxPanX, max(-maxPanX, panOffset.width))
                                panOffset.height = min(maxPanY, max(-maxPanY, panOffset.height))
                            }
                        }
                )
        }
        .frame(width: viewportSize.width, height: viewportSize.height)
        .clipped()
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
        .contentShape(Rectangle())
    }
    
    private var topBar: some View {
        HStack {
            Button {
                audioService.playButtonSound()
                vm.leaveGame()
                if let onLeaveToMainMenu {
                    onLeaveToMainMenu()
                } else {
                    dismiss()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                    Text("LEAVE")
                        .font(.kenneyFuture(size: 18))
                }
                .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(vm.formattedTime)
                .font(.kenneyFuture(size: 28))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    audioService.playButtonSound()
                    withAnimation {
                        scale = min(scale + 0.25, 2.0)
                        lastScale = scale
                        
                    }
                } label: {
                    Image(systemName: "plus.magnifyingglass")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                }
                
                Button {
                    audioService.playButtonSound()
                    withAnimation {
                        scale = max(scale - 0.25, 0.5)
                        lastScale = scale
                    }
                } label: {
                    Image(systemName: "minus.magnifyingglass")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                }
                
                Button {
                    audioService.playButtonSound()
                    withAnimation {
                        scale = 1.0
                        lastScale = scale
                        panOffset = .zero
                    }
                } label: {
                    Text("1x")
                        .font(.kenneyFuture(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var gameBoard: some View {
        let mapHeight = vm.map.count
        let mapWidth = vm.map.first?.count ?? 0
        
        let boardWidth = CGFloat(mapWidth) * tileSize
        let boardHeight = CGFloat(mapHeight) * tileSize
        
        return ZStack(alignment: .topLeading) {
            Color.gray.opacity(0.3)
            
            VStack(spacing: 0) {
                ForEach(0..<mapHeight, id: \.self) { y in
                    HStack(spacing: 0) {
                        ForEach(0..<(vm.map[safe: y]?.count ?? 0), id: \.self) { x in
                            let tile = vm.map[y][x]
                            tileView(for: tile)
                                .frame(width: tileSize, height: tileSize)
                        }
                    }
                }
            }
            
            if vm.showExplosionTrajectory {
                ForEach(vm.bombs.indices, id: \.self) { index in
                    let bomb = vm.bombs[index]
                    ExplosionTrajectoryView(
                        bombX: bomb.x,
                        bombY: bomb.y,
                        map: vm.map,
                        tileSize: tileSize
                    )
                }
            }
            
            ForEach(vm.bombs.indices, id: \.self) { index in
                let bomb = vm.bombs[index]
                BombView()
                    .frame(width: tileSize, height: tileSize)
                    .offset(
                        x: CGFloat(bomb.x) * tileSize,
                        y: CGFloat(bomb.y) * tileSize
                    )
            }
            
            ForEach(vm.explosions.indices, id: \.self) { index in
                let explosion = vm.explosions[index]
                ExplosionView()
                    .frame(width: tileSize, height: tileSize)
                    .offset(
                        x: CGFloat(explosion.x) * tileSize,
                        y: CGFloat(explosion.y) * tileSize
                    )
            }
            
            ForEach(vm.players.filter { $0.alive }) { player in
                AnimatedPlayerView(
                    player: player,
                    isMe: player.id == vm.myID,
                    direction: vm.direction(for: player.id),
                    tileSize: tileSize
                )
            }
        }
        .frame(width: boardWidth, height: boardHeight)
        .cornerRadius(8)
        .clipped()
    }
    
    @ViewBuilder
    private func tileView(for tile: String) -> some View {
        switch tile {
        case "#":
            Image("WallTile")
                .resizable()
                .aspectRatio(contentMode: .fill)
        case ".":
            Image("BrickTile")
                .resizable()
                .aspectRatio(contentMode: .fill)
        default:
            Image("FloorTile")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
    
    private var controlPad: some View {
        VStack(spacing: 10) {
            Button {
                vm.moveUp()
            } label: {
                controlButton(imageName: "ArrowUp")
            }
            
            HStack(spacing: 40) {
                Button {
                    vm.moveLeft()
                } label: {
                    controlButton(imageName: "ArrowLeft")
                }
                
                Button {
                    vm.placeBomb()
                } label: {
                    Image("BombActive")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .background(Color.bombermanRed)
                        .cornerRadius(30)
                }
                
                Button {
                    vm.moveRight()
                } label: {
                    controlButton(imageName: "ArrowRight")
                }
            }
            
            Button {
                vm.moveDown()
            } label: {
                controlButton(imageName: "ArrowDown")
            }
        }
    }
    
    private func controlButton(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .padding(10)
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
    }
    
    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("GAME OVER")
                    .font(.kenneyFuture(size: 40))
                    .foregroundColor(.white)
                
                if let winner = vm.winner {
                    Text(winner == "НИЧЬЯ" ? "DRAW" : "Winner: \(winner)")
                        .font(.kenneyFuture(size: 28))
                        .foregroundColor(.yellow)
                }
                
                VStack(spacing: 12) {
                    Button {
                        audioService.playButtonSound()
                        dismiss()
                    } label: {
                        Text("BACK TO LOBBY")
                            .font(.kenneyFuture(size: 24))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(Color.bombermanGreen)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        audioService.playButtonSound()
                        vm.leaveGame()
                        if let onLeaveToMainMenu {
                            onLeaveToMainMenu()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Text("BACK TO MENU")
                            .font(.kenneyFuture(size: 24))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(Color.bombermanRed)
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 20)
            }
        }
    }
    
    private var defeatOverlay: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("YOU DIED")
                    .font(.kenneyFuture(size: 42))
                    .foregroundColor(.red)

                Text("You can keep watching or leave the match")
                    .font(.kenneyFuture(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                VStack(spacing: 14) {

                    Button {
                        audioService.playButtonSound()
                        showDeathOverlay = false
                    } label: {
                        Text("WATCH GAME")
                            .font(.kenneyFuture(size: 22))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(14)
                    }

                    Button {
                        audioService.playButtonSound()
                        vm.leaveGame()
                        dismiss()
                    } label: {
                        Text("BACK TO LOBBY")
                            .font(.kenneyFuture(size: 22))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.bombermanGreen)
                            .cornerRadius(14)
                    }

                    Button {
                        audioService.playButtonSound()
                        vm.leaveGame()
                        if let onLeaveToMainMenu {
                            onLeaveToMainMenu()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Text("BACK TO MENU")
                            .font(.kenneyFuture(size: 22))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.bombermanRed)
                            .cornerRadius(14)
                    }
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

struct AnimatedPlayerView: View {
    let player: Player
    let isMe: Bool
    let direction: PlayerDirection
    let tileSize: CGFloat
    
    @State private var previousX: Int = 0
    @State private var previousY: Int = 0
    @State private var isMoving: Bool = false
    @State private var animationFrame: Int = 0
    @State private var animationTimer: Timer?
    
    var body: some View {
        PlayerSpriteView(
            isMe: isMe,
            name: player.name,
            direction: direction,
            animationFrame: animationFrame
        )
        .frame(width: tileSize, height: tileSize)
        .offset(
            x: CGFloat(player.x) * tileSize,
            y: CGFloat(player.y) * tileSize
        )
        .animation(.easeOut(duration: 0.15), value: player.x)
        .animation(.easeOut(duration: 0.15), value: player.y)
        .onChange(of: player.x) { newX in
            startWalkingAnimation()
            previousX = newX
        }
        .onChange(of: player.y) { newY in
            startWalkingAnimation()
            previousY = newY
        }
        .onAppear {
            previousX = player.x
            previousY = player.y
        }
        .onDisappear {
            stopWalkingAnimation()
        }
    }
    
    private func startWalkingAnimation() {
        stopWalkingAnimation()
        
        isMoving = true
        animationFrame = 0
        
        var frameIndex = 0
        let frameSequence = [0, 1, 2, 1]
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            frameIndex = (frameIndex + 1) % frameSequence.count
            animationFrame = frameSequence[frameIndex]
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            stopWalkingAnimation()
        }
    }
    
    private func stopWalkingAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        isMoving = false
        animationFrame = 0
    }
}

struct PlayerSpriteView: View {
    let isMe: Bool
    let name: String
    let direction: PlayerDirection
    let animationFrame: Int
    
    var body: some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Image(currentSpriteName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    isMe ? RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue, lineWidth: 2) : nil
                )
        }
    }
    
    private var currentSpriteName: String {
        let frames = direction.animationFrames
        let safeIndex = min(animationFrame, frames.count - 1)
        return frames[safeIndex]
    }
}

struct PlayerView: View {
    let isMe: Bool
    let name: String
    let direction: PlayerDirection
    
    var body: some View {
        PlayerSpriteView(isMe: isMe, name: name, direction: direction, animationFrame: 0)
    }
}

struct BombView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image("BombActive")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 0.3)
                        .repeatForever(autoreverses: true)
                ) {
                    scale = 1.15
                }
            }
    }
}

struct ExplosionView: View {
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Image("Fireball")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.easeOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                ) {
                    opacity = 0.6
                }
            }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    GameView()
}
