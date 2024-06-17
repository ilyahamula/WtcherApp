//
//  CommandViewModel.swift
//  WatcherApp
//
//  Created by macbook on 26.12.2023.
//

import SwiftUI

class BLECommandViewModel: BluetoothViewModel {
    
    public var selectedLightColor: sRGB = sRGB(0, 0, 0)
    
    // TIME GROUP ------------------------------------------------------------------------
    func setTime(_ newTime: sTime) {
        let cmd = "/set_time"
        sendText(cmd + " " + newTime.toString())
    }
    
    func addHour() {
        sendText("/add_hour")
    }
    
    func subHour() {
        sendText("/sub_hour")
    }
    
    func syncTime() { // need to be done with seconds
        let cmd = "/set_time"
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: currentDate)
        let newTime = sTime(hour: components.hour ?? 0, minute: components.minute ?? 0)
        sendText(cmd + " " + newTime.toString())
    }
    
    // LIGHT GROUP ------------------------------------------------------------------------
    func lightOff() {
        sendText("/light_off")
    }
    
    func lightRainbowMode() {
        sendText("/light_rainbow_mode")
    }
    
    func lightWhiteColdMode() {
        sendText("/light_white_cold_mode")
    }
    
    func lightWhiteWarmMode() {
        sendText("/light_white_warm_mode")
    }
    
    func lightCustomMode(_ color: sRGB) {
        let cmd = "/light_custom_mode"
        sendText(cmd + " " + color.toString())
    }
    
    func lightBrightness(_ brightness: UInt8) {
        let cmd = "/light_brightness"
        sendText(cmd + " " + String(brightness))
    }
    
    func setLightMode(_ mode: LightOptions) {
        if (mode == LightOptions.off) {
            lightOff()
        }
        else if (mode == LightOptions.whiteCold) {
            lightWhiteColdMode()
        }
        else if (mode == LightOptions.whiteWarm) {
            lightWhiteWarmMode()
        }
        else if (mode == LightOptions.rainbow) {
            lightRainbowMode()
        }
        else if (mode == LightOptions.custom) {
            lightCustomMode(selectedLightColor)
        }
    }
    
    // WATCH SETTINGS ----------------------------------------------------------------------
    func setDialMode(_ mode: DialMode) {
        if mode == .hour {
            sendText("/dial_digit_hour")
        }
        else if mode == .segment {
            sendText("/dial_segment_hour")
        }
    }
    
    func dialDefaultColors() {
        sendText("/dial_default_colors")
    }
    
    func setHourColor(_ color: sRGB) {
        let cmd = "/set_hour_color"
        sendText(cmd + " " + color.toString())
    }
    
    func setMinColor(_ color: sRGB) {
        let cmd = "/set_min_color"
        sendText(cmd + " " + color.toString())
    }
    
    func setDialBrightness(_ brightness: UInt8) {
        let cmd = "/dial_brightness"
        sendText(cmd + " " + String(brightness))
    }
    
    func setDeepSleepTime(_ time: UInt32) {
        let cmd = "/set_deep_sleep_time"
        sendText(cmd + " " + String(time))
    }
    
    func restartDevice() {
        sendText("/restart")
    }
    
}
