//
//  PlayerSpriteView.swift
//  Bomberman
//
//  Created by Alexandra Lazareva on 13.12.2025.
//

import SwiftUI

struct PlayerSpriteView: View {
    let isMe: Bool
    let name: String
    let spriteName: String

    var body: some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Image(spriteName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    isMe
                    ? RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue, lineWidth: 2)
                    : nil
                )
        }
    }
}
