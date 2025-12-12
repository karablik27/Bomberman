//
//  MenuPlayerAnimation.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 13.12.2025.
//

struct MenuPlayerAnimation {

    static let frames: [MenuDirection: [String]] = [
        .down:  ["PlayerDown", "PlayerDown2", "PlayerDown3"],
        .up:    ["PlayerUp", "PlayerUp2", "PlayerUp3"],
        .left:  ["PlayerLeft", "PlayerLeft2", "PlayerLeft3"],
        .right: ["PlayerRight", "PlayerRight2", "PlayerRight3"]
    ]
}
