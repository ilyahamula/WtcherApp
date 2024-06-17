//
//  sTime.swift
//  WatcherApp
//
//  Created by macbook on 25.12.2023.
//

import Foundation

struct sTime {
    var hour: Int = 0
    var minute: Int = 0
    var seconds: Int = 0
    
    func toString() -> String {
        String(hour) + ":" + String(minute) + ":" + String(seconds)
    }
}
