//
//  LightGroupView.swift
//  WatcherApp
//
//  Created by macbook on 26.12.2023.
//

import SwiftUI

struct LightGroupView: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    @State var currLightMode: LightOptions = LightOptions.off
    
    var body: some View {
        VStack {
            LightModeView().environmentObject(bleController)
            Divider().frame(width: Sizes.SettingWidth.rawValue)
            LightBrightness().environmentObject(bleController)
            Divider().frame(width: Sizes.SettingWidth.rawValue)
            LightColorScheme().environmentObject(bleController)
        }
        .presentationDetents([.medium/*.height(200)*/])
    }
    
}

struct LightModeView: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    @State var currLightMode: LightOptions = LightOptions.off
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(LightOptions.allCases, id: \.rawValue) { lightMode in
                Text(lightMode.rawValue)
                    .padding(.vertical, 20)
                    .frame(width: 100)
                    //.foregroundColor(.gray) // Set text color
                    //.font(.system(size: 15, weight: .bold)) // Set font and size
                    .background {
                        /*
                        ZStack {
                            if currLightMode == lightMode {
                                Capsule()
                                    .fill(.gray)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                        .animation(.snappy, value: currLightMode)
                         */
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        currLightMode = lightMode
                        bleController.setLightMode(currLightMode)
                    }
            }
        }
        .padding(3)
        .background(.primary.opacity(0.06), in: .capsule)
    }
}

struct LightBrightness: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    @State private var value = 50.0
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Text("Brightness:")
                .foregroundColor(.blue) // Set text color
                .font(.system(size: 17, weight: .bold)) // Set font and size
                .padding()
            Slider(
                value: $value,
                in: 5...250,
                step: 1.0) { editing in
                    bleController.lightBrightness(UInt8(value))
                }
        }
        .frame(width: Sizes.SettingWidth.rawValue)
    }
}

struct LightColorScheme: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    
    @State private var hourColor = Color.red
    
    var body: some View {
        HStack {
            Text("Color:")
                .foregroundColor(.blue) // Set text color
                .font(.system(size: 17, weight: .bold)) // Set font and size
                .padding()
    
            HStack {
                Spacer()
                Spacer()
                ColorPicker("", selection: $hourColor, supportsOpacity: false)
                    .frame(width: 80)
                    .onChange(of: hourColor) { oldValue, newValue in
                        if let newColor = newValue.cgColor {
                            bleController.selectedLightColor = convertToRGB(newColor)
                        }
                    }
                Spacer()
            }
        }
        .frame(width: Sizes.SettingWidth.rawValue)
    }
    
    private func convertToRGB(_ value: CGColor) -> sRGB {
        let red = value.components?[0]
        let green = value.components?[1]
        let blue = value.components?[2]
        return sRGB(red!, green!, blue!)
    }
}

#Preview {
    LightGroupView(currLightMode: .off).environmentObject(BLECommandViewModel())
}
