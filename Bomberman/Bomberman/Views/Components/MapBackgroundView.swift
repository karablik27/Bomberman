import SwiftUI

struct MapBackgroundView: View {
    let map: [[Character]]
    let tileSize: CGFloat = 32
    @State private var cameraOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let mapWidth = CGFloat(map[0].count) * tileSize
            let maxOffset = max(0, mapWidth - geometry.size.width)
            let offsetY = (geometry.size.height - CGFloat(map.count) * tileSize) / 2
            
            ZStack {
                ForEach(0..<map.count, id: \.self) { y in
                    ForEach(0..<map[y].count, id: \.self) { x in
                        TileView(
                            tile: map[y][x],
                            xPos: CGFloat(x) * tileSize - cameraOffset,
                            yPos: CGFloat(y) * tileSize + offsetY,
                            tileSize: tileSize
                        )
                    }
                }
            }
            .onAppear {
                startCameraAnimation(maxOffset: maxOffset)
            }
        }
        .opacity(0.3)
    }
    
    private func startCameraAnimation(maxOffset: CGFloat) {
        guard maxOffset > 0 else { return }
        
        withAnimation(.linear(duration: 10).repeatForever(autoreverses: true)) {
            cameraOffset = maxOffset
        }
    }
}

struct TileView: View {
    let tile: Character
    let xPos: CGFloat
    let yPos: CGFloat
    let tileSize: CGFloat
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: tileSize, height: tileSize)
            .position(x: xPos + tileSize/2, y: yPos + tileSize/2)
    }
    
    private var imageName: String {
        if tile == "#" {
            return "WallTile"
        } else if tile == "." {
            return "BrickTile"
        } else {
            return "FloorTile"
        }
    }
}

struct MapLoader {
    static func loadRandomMap() -> [[Character]] {
        let mapNames = ["arena", "corridors", "maze"]
        let randomMap = mapNames.randomElement() ?? "arena"
        return loadMap(named: randomMap)
    }
    
    static func loadMap(named name: String) -> [[Character]] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "txt"),
              let content = try? String(contentsOf: url) else {
            return defaultMap()
        }
        
        return content.split(separator: "\n").map { Array($0) }
    }
    
    static func defaultMap() -> [[Character]] {
        return [
            Array("####################"),
            Array("#p    . . . . .   p#"),
            Array("#. #. #.##.#. #. # #"),
            Array("#.. . . .. . . . ..#"),
            Array("#.##.##.#..#.##.##.#"),
            Array("# . . . . . . . . .#"),
            Array("#.#.#####..#####.#.#"),
            Array("# . . . . . . . . .#"),
            Array("#.#.#####..#####.#.#"),
            Array("# . . . . . . . . .#"),
            Array("#.##.##.#..#.##.##.#"),
            Array("#.. . . .. . . . ..#"),
            Array("#  #. #.##.#. #. # #"),
            Array("#p  . . . . . .   p#"),
            Array("####################")
        ]
    }
}