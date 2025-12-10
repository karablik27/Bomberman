//
//  GameView.swift
//  Bomberman
//
//  Created by Kashapov Amir on 10.12.2025.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var vm = GameViewModel()
    @Environment(\.dismiss) private var dismiss
    
    private let audioService = DIContainer.shared.audioService
    
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
                
                if vm.isGameOver {
                    gameOverOverlay
                }
            }
        }
        .navigationBarHidden(true)
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
        
        var offsetX = viewportSize.width / 2 - cameraX
        var offsetY = viewportSize.height / 2 - cameraY
        
        if boardWidth > viewportSize.width {
            offsetX = min(0, max(viewportSize.width - boardWidth, offsetX))
        } else {
            offsetX = (viewportSize.width - boardWidth) / 2
        }
        
        if boardHeight > viewportSize.height {
            offsetY = min(0, max(viewportSize.height - boardHeight, offsetY))
        } else {
            offsetY = (viewportSize.height - boardHeight) / 2
        }
        
        return GeometryReader { geo in
            gameBoard
                .position(
                    x: boardWidth / 2 + offsetX,
                    y: boardHeight / 2 + offsetY
                )
                .animation(.easeOut(duration: 0.15), value: offsetX)
                .animation(.easeOut(duration: 0.15), value: offsetY)
        }
        .frame(width: viewportSize.width, height: viewportSize.height)
        .clipped()
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }
    
    private var topBar: some View {
        HStack {
            Button {
                audioService.playButtonSound()
                vm.leaveGame()
                dismiss()
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
            
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                Text("LEAVE")
                    .font(.kenneyFuture(size: 18))
            }
            .foregroundColor(.clear)
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
                
                Button {
                    audioService.playButtonSound()
                    vm.leaveGame()
                    dismiss()
                } label: {
                    Text("BACK TO MENU")
                        .font(.kenneyFuture(size: 24))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Color.bombermanRed)
                        .cornerRadius(12)
                }
                .padding(.top, 20)
            }
        }
    }
}

struct AnimatedPlayerView: View {
    let player: Player
    let isMe: Bool
    let tileSize: CGFloat
    
    var body: some View {
        PlayerView(isMe: isMe, name: player.name)
            .frame(width: tileSize, height: tileSize)
            .offset(
                x: CGFloat(player.x) * tileSize,
                y: CGFloat(player.y) * tileSize
            )
            .animation(.easeOut(duration: 0.15), value: player.x)
            .animation(.easeOut(duration: 0.15), value: player.y)
    }
}

struct PlayerView: View {
    let isMe: Bool
    let name: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Image("PlayerDown")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    isMe ? RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue, lineWidth: 2) : nil
                )
        }
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
