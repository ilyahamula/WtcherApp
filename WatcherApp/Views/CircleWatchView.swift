//
//  CircleWatchView.swift
//  WatcherApp
//
//  Created by macbook on 30.11.2023.
//

import SwiftUI
import SceneKit

struct CircleWatchView: View {
    
    @ObservedObject var watch3DViewModel: CircleWatch3DViewModel
    
    var mainScene: SceneView {
        let scene = SCNScene()
        scene.rootNode.addChildNode(watch3DViewModel.watchNode)
        return SceneView(scene: scene, options: [.autoenablesDefaultLighting])
    }
    
    var body: some View {
        mainScene
    }
}

#Preview {
    CircleWatchView(watch3DViewModel: CircleWatch3DViewModel())
}
