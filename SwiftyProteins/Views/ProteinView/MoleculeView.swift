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
        let scene = SCNScene()
        
        for atom in molecule.atoms {
            let sphere = SCNSphere(radius: 0.3)
            sphere.firstMaterial?.diffuse.contents = getColor(for: atom.element)
            let node = SCNNode(geometry: sphere)
            node.position = SCNVector3(atom.x, atom.y, atom.z)
            scene.rootNode.addChildNode(node)
        }
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
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

