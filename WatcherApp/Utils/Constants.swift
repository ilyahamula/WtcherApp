//
//  Constants.swift
//  WatcherApp
//
//  Created by macbook on 19.01.2024.
//

import Foundation

enum Sizes: CGFloat {
    case SettingWidth = 350.0
}

enum DialMode: String, CaseIterable {
    case hour = "Hour"
    case segment = "Segment"
}

enum LightOptions : String, CaseIterable {
    case off = "off"
    case whiteCold = "cold"
    case whiteWarm = "warm"
    case rainbow = "rainbow"
    case custom = "custom"
}
