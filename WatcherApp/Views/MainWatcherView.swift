//
//  MainWatcherView.swift
//  WatcherApp
//
//  Created by macbook on 29.11.2023.
//

import SwiftUI

struct MainWatcherView: View {
    
    @ObservedObject var bleCommander = BLECommandViewModel()
    private var flag: Bool = true
    
    var body: some View {
        //MainWatcherViewGroup().environmentObject(bleCommander)
        
        if bleCommander.watchConnected {
            MainWatcherViewGroup().environmentObject(bleCommander)
        }
        else if bleCommander.tryingToConnect {
            LoadingSpinner()
        }
        else {
            Text("Failed to connect to CircleWatch")
        }
    }
}

struct MainWatcherViewGroup: View {
    
    @EnvironmentObject var bleController: BLECommandViewModel
    @ObservedObject var watch3DModel = CircleWatch3DViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                CircleWatchView(watch3DViewModel: watch3DModel)
                    //.frame(height: geometry.size.height * 0.90)
                    .ignoresSafeArea()
                CircleWatchControlView().environmentObject(bleController)
                    .frame(height: geometry.size.height * 0.15)
                    .background(Color.gray)
            }
        }
    }
}

#Preview {
    MainWatcherViewGroup()
}
