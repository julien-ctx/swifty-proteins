//
//  MoleculeView.swift
//  SwiftyProteins
//
//  Created by Julien Caucheteux on 28/05/2024.
//

import Foundation
import SwiftUI
import SceneKit

struct MoleculeView: UIViewRepresentable {
    var molecule: Molecule
    
    // Required method
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.scene = createScene()
        return scnView
    }
    
    // Required method
    func updateUIView(_ uiView: SCNView, context: Context) {}
    
    private func createScene() -> SCNScene {
        var scene = SCNScene()
        
        for atom in molecule.atoms {
            let sphere = SCNSphere(radius: 0.3)
            sphere.firstMaterial?.diffuse.contents = getColor(for: atom.element)
            let node = SCNNode(geometry: sphere)
            node.position = SCNVector3(atom.x, atom.y, atom.z)
            scene.rootNode.addChildNode(node)
        }
        
        addCamera(for: &scene)
        
        return scene
    }
    
    private func degreesToRadians(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    // https://stackoverflow.com/questions/21544336/how-to-position-the-camera-so-that-my-main-object-is-entirely-visible-and-fit-to
    // https://forum.unity.com/threads/fit-object-exactly-into-perspective-cameras-field-of-view-focus-the-object.496472/
    private func addCamera(for scene: inout SCNScene) -> Void {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        let minAtomX = molecule.atoms.min { $0.x < $1.x }
        let maxAtomX = molecule.atoms.max { $0.x < $1.x }
        
        let minAtomY = molecule.atoms.min { $0.y < $1.y }
        let maxAtomY = molecule.atoms.max { $0.y < $1.y }
        
        let minAtomZ = molecule.atoms.min { $0.z < $1.z }
        let maxAtomZ = molecule.atoms.max { $0.z < $1.z }
        
        if let minX = minAtomX?.x, let maxX = maxAtomX?.x, let minZ = minAtomZ?.z, let maxZ = maxAtomZ?.z, let minY = minAtomY?.y, let maxY = maxAtomY?.y, let fov = cameraNode.camera?.fieldOfView {
            
            let cameraDistance = 2.0;
            let proteinSize = [maxX - minX, maxY - minY, maxZ - minZ].max()
            let cameraView = 2.0 * tan(0.5 * degreesToRadians(fov))
            
            guard let maxSize = proteinSize else {
                return
            }
            var distance = cameraDistance * maxSize / cameraView
            distance += 0.5 * maxSize;
            
            cameraNode.position = SCNVector3(x: 0, y: 0, z: Float(distance))
            scene.rootNode.addChildNode(cameraNode)
        }
    }
    
    // https://en.wikipedia.org/wiki/CPK_coloring
    private func getColor(for element: String) -> UIColor {
        switch element {
        case "H":
            return .white
        case "C":
            return .black
        case "N":
            return .blue
        case "O":
            return .red
        case "F", "Cl":
            return .green
        case "Br":
            return UIColor(red: 0.65, green: 0.16, blue: 0.16, alpha: 1.0)
        case "I":
            return UIColor(red: 0.58, green: 0.0, blue: 0.83, alpha: 1.0)
        case "He", "Ne", "Ar", "Kr", "Xe":
            return .cyan
        case "P":
            return .orange
        case "S":
            return .yellow
        case "B":
            return UIColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0)
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            return UIColor(red: 0.53, green: 0.12, blue: 0.47, alpha: 1.0)
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            return UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0)
        case "Fe":
            return UIColor(red: 0.80, green: 0.33, blue: 0.0, alpha: 1.0)
        default:
            return UIColor(red: 1.0, green: 0.75, blue: 0.80, alpha: 1.0)
        }
    }
}

