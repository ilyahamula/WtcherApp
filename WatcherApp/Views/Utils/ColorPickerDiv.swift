//
//  ColorPickerDiv.swift
//  WatcherApp
//
//  Created by macbook on 19.01.2024.
//

import SwiftUI

struct ColorPickerDiv: View {
    @State private var bgColor = Color.red

        var body: some View {
            VStack {
                ColorPicker("Set the background color", selection: $bgColor, supportsOpacity: false)
            }
        }
}

#Preview {
    ColorPickerDiv()
}
