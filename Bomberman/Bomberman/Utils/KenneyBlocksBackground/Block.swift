//
//  Block.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 10.12.2025.
//

import SwiftUI

struct Block: Identifiable {
    let id = UUID()
    let imageName: String
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var rotation: Double
    var velocityY: CGFloat
    var velocityX: CGFloat
    var rotationSpeed: Double
    var isSettled: Bool = false
    var isFrozen: Bool = false
    var touchCount: Int = 0
}

