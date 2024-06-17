//
//  SettingsGroupView.swift
//  WatcherApp
//
//  Created by macbook on 26.12.2023.
//
import SwiftUI

struct SettingsGroupView: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    
    var body: some View {
        VStack {
            //Divider().frame(width: Sizes.SettingWidth.rawValue)
            SettingBrightness().environmentObject(bleController)
            Divider().frame(width: Sizes.SettingWidth.rawValue)
            SettingDialMode().environmentObject(bleController)
            Divider().frame(width: Sizes.SettingWidth.rawValue)
            SettingColorScheme().environmentObject(bleController)
            Divider().frame(width: Sizes.SettingWidth.rawValue)
            SettingDeepSleep().environmentObject(bleController)
        }
        .presentationDetents([.medium/*.height(200)*/])
    }
}


struct SettingBrightness: View {
    
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
                    bleController.setDialBrightness(UInt8(value))
                }
        }
        .frame(width: Sizes.SettingWidth.rawValue)
    }
}

struct SettingDialMode: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    @State private var currentMode: DialMode = .segment
    @Namespace private var animation
    
    var body: some View {
        HStack {
            Text("Mode:")
                .foregroundColor(.blue) // Set text color
                .font(.system(size: 17, weight: .bold)) // Set font and size
                .padding()
            Spacer()
            HStack(spacing: 0) {
                ForEach(DialMode.allCases, id: \.rawValue) { dialMode in
                    Text(dialMode.rawValue)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                        //.foregroundColor(.gray) // Set text color
                        //.font(.system(size: 15, weight: .bold)) // Set font and size
                        .background {
                            ZStack {
                                if currentMode == dialMode {
                                    Capsule()
                                        .fill(.gray)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                }
                            }
                            .animation(.snappy, value: currentMode)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            currentMode = dialMode
                            bleController.setDialMode(dialMode)
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.06), in: .capsule)
        }
        .frame(width: Sizes.SettingWidth.rawValue)
    }
}

struct SettingColorScheme: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    
    @State private var hourColor = Color.red
    @State private var minColor = Color.red
    @State private var isDefPressed = false
    
    var body: some View {
        HStack {
            Text("Color:")
                .foregroundColor(.blue) // Set text color
                .font(.system(size: 17, weight: .bold)) // Set font and size
                .padding()
    

            HStack {
                Text("Default")
                    .frame(width: 70, height: 35)
                    .background {
                        Capsule()
                            .fill(.cyan)
                            //.scaleEffect(isDefPressed ? 0.9 : 1.0)
                            //.animation(.easeInOut(duration: 0.2))
                    }
                    .contentShape(.rect)
                    .foregroundColor(.white)
                    .onTapGesture {
                        //isDefPressed = true
                        bleController.dialDefaultColors()
                        hourColor = Color.white
                        minColor = Color.blue
                    }
                 
                Spacer()
                Spacer()
                ColorPicker("Hour", selection: $hourColor, supportsOpacity: false)
                    .frame(width: 80)
                    .onChange(of: hourColor) { oldValue, newValue in
                        if let newColor = newValue.cgColor {
                            bleController.setHourColor(convertToRGB(newColor))
                        }
                    }
                Spacer()
                ColorPicker("Min", selection: $minColor, supportsOpacity: false)
                    .frame(width: 80)
                    .onChange(of: minColor) { oldValue, newValue in
                        if let newColor = newValue.cgColor {
                            bleController.setMinColor(convertToRGB(newColor))
                        }
                    }
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

struct SettingDeepSleep: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    @State private var inputValue: Int = 0
    
    var body: some View {
        HStack {
            
            Text("Deep Sleep time:")
                .foregroundColor(.blue) // Set text color
                .font(.system(size: 17, weight: .bold)) // Set font and size
                .padding()
            TextField("Enter a number", value: $inputValue, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
            Stepper {
                //Image(systemName: "arrow.up.circle")
                   } onIncrement: {
                       inputValue += 1
                   } onDecrement: {
                       inputValue -= 1
                   }
                   .padding(5)

                        
        }
    }
}

/*
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .cornerRadius(8)
            //.frame(width: 70, height: 35)
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2))
    }
}
*/

#Preview {
    SettingsGroupView().environmentObject(BLECommandViewModel())
}
