//
//  BlockView.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct BlockView: View {
    let block: Block

    var body: some View {
        Image(block.imageName)
            .resizable()
            .frame(width: block.size, height: block.size)
            .rotationEffect(.degrees(block.rotation))
            .position(x: block.x, y: block.y)
    }
}

