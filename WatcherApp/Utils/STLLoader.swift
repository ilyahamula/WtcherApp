//
//  STLLoader.swift
//  MLRoomPlanMatcher
//
//  Created by User on 31.10.2023.
//

import Foundation
import SceneKit

public enum STLError: Swift.Error { 
    case fileTooSmall(size: Int)
    case unexpectedFileSize(expected: Int, actual: Int)
    case triangleCountMismatch(diff: Int)
    case failedToOpenFile(file: String)
}

public enum UnitScale: Float {
    case meter = 1.0
    case millimeter = 0.001
}

class STLLoader {
    private static let minSizeBinSTL: Int = 84
    
    static func createGeometryFromFile(filePath: String, unit scale: UnitScale = .meter) throws -> SCNGeometry {
        if let stlData = DataLoader.loadBundledContent(fromFileNamed: filePath) {
            return try createGeometryFromData(stlBinData: stlData, unit: scale)
        }
        throw STLError.failedToOpenFile(file: filePath)
    }
    
    static func createGeometryFromByteString(byteData: String, unit scale: UnitScale = .meter) throws -> SCNGeometry {
        if let stlData = Data(base64Encoded: byteData) {
            return try createGeometryFromData(stlBinData: stlData, unit: scale)
        }
        return SCNGeometry()
    }
    
    static func createGeometryFromData(stlBinData: Data, unit scale: UnitScale = .meter) throws -> SCNGeometry {
        let modelNode = SCNNode()
        guard stlBinData.count > minSizeBinSTL else {
            throw STLError.fileTooSmall(size: stlBinData.count)
        }
        
        let name = String(data: stlBinData.subdata(in: 0..<80), encoding: .ascii)
        let triangleTarget: UInt32 = stlBinData.scanValue(start: 80, length: 4)
        let triangleBytes = MemoryLayout<Triangle>.size
        let expectedFileSize = minSizeBinSTL + triangleBytes * Int(triangleTarget)
        guard stlBinData.count == expectedFileSize else {
            throw STLError.unexpectedFileSize(expected: expectedFileSize, actual: stlBinData.count)
        }

        var normals = Data()
        var vertices = Data()
        var trianglesCounted: Int = 0
        for index in stride(from: minSizeBinSTL, to: stlBinData.count, by: triangleBytes) {
            trianglesCounted += 1
            
            var triangleData = stlBinData.subdata(in: index..<index+triangleBytes)
            var triangle: Triangle = triangleData.withUnsafeMutableBytes { $0.pointee }
            
            let normalData = triangle.normal.unsafeData()
            normals.append(normalData)
            normals.append(normalData)
            normals.append(normalData)
            
            vertices.append(triangle.v1.unsafeData())
            vertices.append(triangle.v2.unsafeData())
            vertices.append(triangle.v3.unsafeData())
        }
        
        guard triangleTarget == trianglesCounted else {
            throw STLError.triangleCountMismatch(diff: Int(triangleTarget) - trianglesCounted)
        }
        
        let vertexSource = SCNGeometrySource(data: vertices,
                                             semantic: .vertex,
                                             vectorCount: trianglesCounted * 3,
                                             usesFloatComponents: true,
                                             componentsPerVector: 3,
                                             bytesPerComponent: MemoryLayout<Float>.size,
                                             dataOffset: 0,
                                             dataStride: MemoryLayout<SCNVector3>.size)
        
        let normalSource = SCNGeometrySource(data: normals,
                                             semantic: .normal,
                                             vectorCount: trianglesCounted * 3,
                                             usesFloatComponents: true,
                                             componentsPerVector: 3,
                                             bytesPerComponent: MemoryLayout<Float>.size,
                                             dataOffset: 0,
                                             dataStride: MemoryLayout<SCNVector3>.size)
        
        // The SCNGeometryElement accepts `nil` as a value for the index-data, and will then generate a list
        // of auto incrementing indices. It still requires a number of bytes used for the index, whether it
        // is actually used is unknown to me.
        let use8BitIndices = MemoryLayout<UInt8>.size
        let countedTriangles = SCNGeometryElement(data: nil,
                                                  primitiveType: .triangles,
                                                  primitiveCount: trianglesCounted,
                                                  bytesPerIndex: use8BitIndices)
        
        return SCNGeometry(sources: [vertexSource, normalSource], elements: [countedTriangles])
    }
}

private extension Data {
    func scanValue<T>(start: Int, length: Int) -> T {
        return self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
    }
}

struct Triangle {
    var normal: SCNVector3
    var v1: SCNVector3
    var v2: SCNVector3
    var v3: SCNVector3
    var attributes: UInt16
}



extension SCNVector3 {
    mutating func unsafeData() -> Data {
        return Data(buffer: UnsafeBufferPointer(start: &self, count: 1))
    }
}
