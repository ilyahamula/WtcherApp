//
//  LoadingSpinner.swift
//  WatcherApp
//
//  Created by macbook on 26.12.2023.
//

import SwiftUI

struct LoadingSpinner: View {
    var body: some View {
        ProgressView("Connecting to CircleWatch")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
    }
}

#Preview {
    LoadingSpinner()
}
