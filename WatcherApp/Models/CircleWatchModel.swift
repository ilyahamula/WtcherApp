//
//  CircleWatchModel.swift
//  WatcherApp
//
//  Created by macbook on 09.01.2024.
//

import Foundation

struct CircleWatchModel {
    var watchTime: sTime
    var dialMode: DialMode
    var dialBrightness: UInt8
    var hoursColor: sRGB
    var minColor: sRGB
    var deepSleepTime: UInt64
}
