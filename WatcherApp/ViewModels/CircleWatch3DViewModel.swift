//
//  CircleWatch3DViewModel.swift
//  WatcherApp
//
//  Created by macbook on 07.01.2024.
//

import SceneKit

class CircleWatch3DViewModel: ObservableObject {
    
    var watchNode = SCNNode()
    
    init() {
        let metalMaterial = SCNMaterial()
        metalMaterial.lightingModel = .physicallyBased
        metalMaterial.diffuse.contents = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) // Adjust color as needed
        metalMaterial.metalness.contents = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        metalMaterial.roughness.contents = 0.2
        let _ = loadWatchPartNode("CircleWatch 3D models/Dial.stl", material: metalMaterial)
        
        let _ = loadWatchPartNode("CircleWatch 3D models/Main transparent part.stl")
        let _ = loadWatchPartNode("CircleWatch 3D models/Back part.stl")
        
        let _ = loadWatchPartNode("CircleWatch 3D models/9.stl")
        let _ = loadWatchPartNode("CircleWatch 3D models/10.stl")
        let _ = loadWatchPartNode("CircleWatch 3D models/11.stl")
        let _ = loadWatchPartNode("CircleWatch 3D models/12.stl")
    }
    
    // LOAD MESH PARTS
    private func loadWatchPartNode(_ path: String, material: SCNMaterial? = nil) -> SCNNode? {
        if let meshData = DataLoader.loadBundledContent(fromFileNamed: path) {
            do {
                let geometry = try STLLoader.createGeometryFromData(stlBinData: meshData)
                
                if let mat = material {
                    geometry.firstMaterial = mat
                }

                let geometryNode = SCNNode(geometry: geometry)
                watchNode.addChildNode(geometryNode)
                return geometryNode
            }
            catch {
                print("Mesh loading error: \(error)")
            }
        }
        return nil
    }
}
