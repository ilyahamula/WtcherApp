//
//  CircleWatchControlView.swift
//  WatcherApp
//
//  Created by macbook on 30.11.2023.
//

import SwiftUI

struct CircleWatchControlView: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    @State var timeGroupFlag: Bool = false
    @State var lightGroupFlag: Bool = false
    @State var settingsGroupFlag: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            timeGroupButton
            Spacer()
            Spacer()
            lightGroupButton
            Spacer()
            Spacer()
            settingsGroupButton
            Spacer()
        }
        .foregroundColor(.yellow)
        .sheet(isPresented: $timeGroupFlag, content: {
            TimeGroupView().environmentObject(bleController)
        })
        .sheet(isPresented: $lightGroupFlag, content: {
            LightGroupView().environmentObject(bleController)
        })
        .sheet(isPresented: $settingsGroupFlag, content: {
            SettingsGroupView().environmentObject(bleController)
        })
    }
    
    var timeGroupButton: some View {
        Button {
            timeGroupFlag.toggle()
        } label: {
            VStack {
                Image(systemName: "clock.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                Text("Time")
                    .font(.headline)
            }
            //Label("Time", systemImage: "clock.fill")
        }
    }
    
    var lightGroupButton: some View {
        Button {
            lightGroupFlag.toggle()
        } label: {
            VStack {
                Image(systemName: "lightbulb.circle.fill")
                    .font(.system(size: 50))
                Text("Light")
                    .font(.headline)
            }
            //Label("Light", systemImage: "lightbulb.circle.fill")
        }
    }
    
    var settingsGroupButton: some View {
        Button {
            settingsGroupFlag.toggle()
        } label: {
            VStack {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 50))
                Text("Settings")
                    .font(.headline)
            }
            //Label("Settings", systemImage: "gearshape.fill")
        }
    }
}

#Preview {
    
    CircleWatchControlView().environmentObject(BLECommandViewModel())
}
