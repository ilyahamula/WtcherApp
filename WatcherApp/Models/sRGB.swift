//
//  sRGB.swift
//  WatcherApp
//
//  Created by macbook on 25.12.2023.
//

import Foundation

struct sRGB {
    var r: UInt8 = 0
    var g: UInt8 = 0
    var b: UInt8 = 0

    init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) {
        r = UInt8(255 * red)
        g = UInt8(255 * green)
        b = UInt8(255 * blue)
    }
    
    func toString() -> String {
        String(r) + "," + String(g) + "," + String(b)
    }
}
