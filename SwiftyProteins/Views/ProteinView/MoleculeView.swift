import Foundation
import SwiftUI
import SceneKit

struct MoleculeView: UIViewRepresentable {
    var molecule: Molecule
    var onError: (String) -> Void
    
    // Coordinator is used to have mutable variables because struct is immutable.
    class Coordinator {
        var minX: Float?
        var maxX: Float?
        var minY: Float?
        var maxY: Float?
        var minZ: Float?
        var maxZ: Float?
        var cameraNode: SCNNode?
        
        init() {}
        
        func getMinMax(molecule: Molecule) {
            minX = molecule.atoms.min(by: { $0.x < $1.x })?.x
            maxX = molecule.atoms.max(by: { $0.x < $1.x })?.x
            minY = molecule.atoms.min(by: { $0.y < $1.y })?.y
            maxY = molecule.atoms.max(by: { $0.y < $1.y })?.y
            minZ = molecule.atoms.min(by: { $0.z < $1.z })?.z
            maxZ = molecule.atoms.max(by: { $0.z < $1.z })?.z
        }
        
        func recenterProtein() {
            guard let cameraNode = cameraNode,
                  let minX = minX, let maxX = maxX,
                  let minY = minY, let maxY = maxY,
                  let minZ = minZ, let maxZ = maxZ else {
                return
            }
            
            if let fov = cameraNode.camera?.fieldOfView {
                let cameraDistance: Float = 2.0
                let proteinSize: Float? = [maxX - minX, maxY - minY, maxZ - minZ].max()
                let cameraView: Float = 2.0 * tan(Coordinator.degreesToRadians(Float(fov)) / 2)
                
                guard let maxSize = proteinSize else {
                    return
                }
                var distance: Float = cameraDistance * maxSize / cameraView
                distance += 0.5 * maxSize
                
                cameraNode.position = SCNVector3(x: 0, y: 0, z: Float(distance))
            }
        }
        
        static func degreesToRadians(_ number: Float) -> Float {
            return number * .pi / 180
        }
    }
    
    // Required method
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    // Required method
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        
        context.coordinator.getMinMax(molecule: molecule)
        scnView.scene = createScene(coordinator: context.coordinator)
        return scnView
    }
    
    // Required method
    func updateUIView(_ uiView: SCNView, context: Context) {}
    
    private func createScene(coordinator: Coordinator) -> SCNScene {
        var scene = SCNScene()
        
        for atom in molecule.atoms {
            addAtom(for: &scene, atom)
            addConnections(for: &scene, atom)
        }
        addCamera(for: &scene, coordinator: coordinator)
        
        return scene
    }
    
    private func addAtom(for scene: inout SCNScene, _ atom: Atom) -> Void {
        let sphere = SCNSphere(radius: 0.3)
        sphere.firstMaterial?.diffuse.contents = getColor(for: atom.element)
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(atom.x, atom.y, atom.z)
        scene.rootNode.addChildNode(node)
    }
    
    private func getAtomCoordinates(for index: Int) -> SCNVector3 {
        let result = molecule.atoms.first(where: { value -> Bool in
            value.index == index
        })
        guard let result = result else {
            onError("Invalid atom specified in CONECT line")
            return SCNVector3(x: 0, y: 0, z: 0)
        }
        return SCNVector3(x: result.x, y: result.y, z: result.z)
    }
    
    private func addConnections(for scene: inout SCNScene, _ atom: Atom) -> Void {
        for connection in atom.connections {
            let from: SCNVector3 = SCNVector3(x: atom.x, y: atom.y, z: atom.z)
            let to: SCNVector3 = getAtomCoordinates(for: connection)
            
            let dx = to.x - from.x
            let dy = to.y - from.y
            let dz = to.z - from.z
            let distance = sqrtf(dx * dx + dy * dy + dz * dz)
            
            let cylinder = SCNCylinder(radius: 0.05, height: CGFloat(distance))
            cylinder.firstMaterial?.diffuse.contents = UIColor.gray
            
            let lineNode = SCNNode(geometry: cylinder)
            lineNode.position = SCNVector3(x: (from.x + to.x) / 2,
                                           y: (from.y + to.y) / 2,
                                           z: (from.z + to.z) / 2)
            
            lineNode.look(at: to, up: scene.rootNode.worldUp, localFront: lineNode.worldUp)
            
            scene.rootNode.addChildNode(lineNode)
        }
    }
    
    private func addCamera(for scene: inout SCNScene, coordinator: Coordinator) -> Void {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        guard let minX = coordinator.minX, let maxX = coordinator.maxX, let minZ = coordinator.minZ, let maxZ = coordinator.maxZ, let minY = coordinator.minY, let maxY = coordinator.maxY else {
            onError("Camera position could not be computed")
            return
        }
        
        if let fov = cameraNode.camera?.fieldOfView {
            let cameraDistance: Float = 2.0
            let proteinSize: Float? = [maxX - minX, maxY - minY, maxZ - minZ].max()
            let cameraView: Float = 2.0 * tan(Coordinator.degreesToRadians(Float(fov)) / 2)
            
            guard let maxSize = proteinSize else {
                onError("Protein size could not be computed")
                return
            }
            var distance: Float = cameraDistance * maxSize / cameraView
            distance += 0.5 * maxSize
            
            cameraNode.position = SCNVector3(x: 0, y: 0, z: Float(distance))
            scene.rootNode.addChildNode(cameraNode)
            coordinator.cameraNode = cameraNode // Store the reference to the camera node
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
