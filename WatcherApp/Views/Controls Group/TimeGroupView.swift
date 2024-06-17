//
//  TimeGroupView.swift
//  WatcherApp
//
//  Created by macbook on 26.12.2023.
//

import SwiftUI

struct TimeGroupView: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    @State private var selectedTime = Date()
    
    var body: some View {
        VStack {
            DatePicker("Select a time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .onChange(of: selectedTime, initial: true, {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute, .second], from: selectedTime)
                    let newTime = sTime(hour: components.hour ?? 0, minute: components.minute ?? 0,
                                        seconds: components.second ?? 0)
                    bleController.setTime(newTime)
                })
        }
        .padding()
        .presentationDetents([.height(200)])
    }
    
    private var formattedTime: String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: selectedTime)
    }
}

#Preview {
    TimeGroupView().environmentObject(BLECommandViewModel())
}
