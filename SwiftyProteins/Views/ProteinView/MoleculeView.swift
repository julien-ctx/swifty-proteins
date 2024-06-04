//
//  MoleculeView.swift
//  SwiftyProteins
//
//  Created by Julien Caucheteux on 28/05/2024.
//

import Foundation
import SwiftUI
import SceneKit

let elementNames: [String: String] = [
    "H": "Hydrogen",
    "He": "Helium",
    "Li": "Lithium",
    "Be": "Beryllium",
    "B": "Boron",
    "C": "Carbon",
    "N": "Nitrogen",
    "O": "Oxygen",
    "F": "Fluorine",
    "Ne": "Neon",
    "Na": "Sodium",
    "Mg": "Magnesium",
    "Al": "Aluminum",
    "Si": "Silicon",
    "P": "Phosphorus",
    "S": "Sulfur",
    "Cl": "Chlorine",
    "Ar": "Argon",
    "K": "Potassium",
    "Ca": "Calcium",
    "Sc": "Scandium",
    "Ti": "Titanium",
    "V": "Vanadium",
    "Cr": "Chromium",
    "Mn": "Manganese",
    "Fe": "Iron",
    "Co": "Cobalt",
    "Ni": "Nickel",
    "Cu": "Copper",
    "Zn": "Zinc",
    "Ga": "Gallium",
    "Ge": "Germanium",
    "As": "Arsenic",
    "Se": "Selenium",
    "Br": "Bromine",
    "Kr": "Krypton",
    "Rb": "Rubidium",
    "Sr": "Strontium",
    "Y": "Yttrium",
    "Zr": "Zirconium",
    "Nb": "Niobium",
    "Mo": "Molybdenum",
    "Tc": "Technetium",
    "Ru": "Ruthenium",
    "Rh": "Rhodium",
    "Pd": "Palladium",
    "Ag": "Silver",
    "Cd": "Cadmium",
    "In": "Indium",
    "Sn": "Tin",
    "Sb": "Antimony",
    "Te": "Tellurium",
    "I": "Iodine",
    "Xe": "Xenon",
    "Cs": "Cesium",
    "Ba": "Barium",
    "La": "Lanthanum",
    "Ce": "Cerium",
    "Pr": "Praseodymium",
    "Nd": "Neodymium",
    "Pm": "Promethium",
    "Sm": "Samarium",
    "Eu": "Europium",
    "Gd": "Gadolinium",
    "Tb": "Terbium",
    "Dy": "Dysprosium",
    "Ho": "Holmium",
    "Er": "Erbium",
    "Tm": "Thulium",
    "Yb": "Ytterbium",
    "Lu": "Lutetium",
    "Hf": "Hafnium",
    "Ta": "Tantalum",
    "W": "Tungsten",
    "Re": "Rhenium",
    "Os": "Osmium",
    "Ir": "Iridium",
    "Pt": "Platinum",
    "Au": "Gold",
    "Hg": "Mercury",
    "Tl": "Thallium",
    "Pb": "Lead",
    "Bi": "Bismuth",
    "Po": "Polonium",
    "At": "Astatine",
    "Rn": "Radon",
    "Fr": "Francium",
    "Ra": "Radium",
    "Ac": "Actinium",
    "Th": "Thorium",
    "Pa": "Protactinium",
    "U": "Uranium",
    "Np": "Neptunium",
    "Pu": "Plutonium",
    "Am": "Americium",
    "Cm": "Curium",
    "Bk": "Berkelium",
    "Cf": "Californium",
    "Es": "Einsteinium",
    "Fm": "Fermium",
    "Md": "Mendelevium",
    "No": "Nobelium",
    "Lr": "Lawrencium",
    "Rf": "Rutherfordium",
    "Db": "Dubnium",
    "Sg": "Seaborgium",
    "Bh": "Bohrium",
    "Hs": "Hassium",
    "Mt": "Meitnerium",
    "Ds": "Darmstadtium",
    "Rg": "Roentgenium",
    "Cn": "Copernicium",
    "Nh": "Nihonium",
    "Fl": "Flerovium",
    "Mc": "Moscovium",
    "Lv": "Livermorium",
    "Ts": "Tennessine",
    "Og": "Oganesson"
]

struct MoleculeView: UIViewRepresentable {
    var molecule: Molecule
    var onImageGenerated: ((UIImage) -> Void)
    
    // Coordinator is used to have mutable variables because struct is immutable.
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var molecule: Molecule
        var scnView: SCNView?
        var tooltipView: UIView?
        
        init(molecule: Molecule) {
            self.molecule = molecule
        }
        
        @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
            guard let scnView = scnView else { return }
            
            let location = gestureRecognize.location(in: scnView)
            let hitResults = scnView.hitTest(location, options: [:])
            
            self.tooltipView?.removeFromSuperview()
            self.tooltipView = nil
            
            if let result = hitResults.first,
               let node = result.node as SCNNode?,
               let atomIndex = node.name,
               let atom = self.molecule.atoms.first(where: { "\($0.index)" == atomIndex }) {
                if let elementFullName = elementNames[atom.element] {
                    self.showTooltip(at: location, text: "\(atom.element) - \(elementFullName)")
                } else {
                    self.showTooltip(at: location, text: "\(atom.element)")
                }
            }
        }
        
        func showTooltip(at location: CGPoint, text: String) {
            guard let scnView = scnView else { return }
            
            let tooltip = UILabel()
            tooltip.text = text
            tooltip.textColor = .white
            tooltip.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            tooltip.textAlignment = .center
            tooltip.font = UIFont.systemFont(ofSize: 14)
            tooltip.sizeToFit()
            tooltip.layer.cornerRadius = 5
            tooltip.layer.masksToBounds = true
            
            var tooltipFrame = tooltip.frame
            tooltipFrame.size.width += 10
            tooltipFrame.size.height += 5
            tooltip.frame = tooltipFrame
            
            let tooltipContainer = UIView(frame: tooltipFrame)
            tooltipContainer.backgroundColor = .clear
            tooltipContainer.addSubview(tooltip)
            tooltip.center = CGPoint(x: tooltipContainer.bounds.midX, y: tooltipContainer.bounds.midY)
            
            tooltipContainer.center = CGPoint(x: location.x, y: location.y - tooltipContainer.frame.height / 2 - 10)
            scnView.addSubview(tooltipContainer)
            
            self.tooltipView = tooltipContainer
        }
        
        private func degreesToRadians(_ number: Float) -> Float {
            return number * .pi / 180
        }
        
        func computeCameraPosition() -> SCNVector3 {
            if molecule.atoms.count == 1 {
                return SCNVector3(x: 0, y: 0, z: 10)
            }
            
            guard let minX = molecule.atoms.min(by: { $0.x < $1.x })?.x,
                  let maxX = molecule.atoms.max(by: { $0.x < $1.x })?.x,
                  let minY = molecule.atoms.min(by: { $0.y < $1.y })?.y,
                  let maxY = molecule.atoms.max(by: { $0.y < $1.y })?.y,
                  let minZ = molecule.atoms.min(by: { $0.z < $1.z })?.z,
                  let maxZ = molecule.atoms.max(by: { $0.z < $1.z })?.z else {
                return SCNVector3(x: 0, y: 0, z: 10)
            }
            
            let cameraDistance: Float = 2.0
            let maxSize = max(maxX - minX, maxY - minY, maxZ - minZ)
            let cameraView: Float = 2.0 * tan(degreesToRadians(60.0) / 2)
            
            var distance: Float = cameraDistance * maxSize / cameraView
            distance += 0.5 * maxSize
            
            return SCNVector3(x: 0, y: 0, z: distance)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(molecule: molecule)
    }
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(gestureRecognize:)))
        scnView.addGestureRecognizer(tapGesture)
        
        context.coordinator.scnView = scnView
        
        let scene = self.createScene(coordinator: context.coordinator)
        
        scnView.scene = scene
        
        // Capture image after a short delay to ensure the view is fully rendered
        DispatchQueue.main.async {
            self.onImageGenerated(scnView.snapshot())
        }
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
    
    private func createScene(coordinator: Coordinator) -> SCNScene {
        let scene = SCNScene()
        
        for atom in molecule.atoms {
            addAtom(to: scene, atom)
            addConnections(to: scene, atom)
        }
        addCamera(to: scene, coordinator: coordinator)
        
        return scene
    }
    
    private func addAtom(to scene: SCNScene, _ atom: Atom) {
        let sphere = SCNSphere(radius: 0.3)
        sphere.firstMaterial?.diffuse.contents = getColor(for: atom.element)
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(atom.x, atom.y, atom.z)
        node.name = "\(atom.index)"
        scene.rootNode.addChildNode(node)
    }
    
    private func getAtomCoordinates(for index: Int) -> SCNVector3 {
        guard let result = molecule.atoms.first(where: { $0.index == index }) else {
            print("Invalid atom specified in CONECT line")
            return SCNVector3(x: 0, y: 0, z: 0)
        }
        return SCNVector3(x: result.x, y: result.y, z: result.z)
    }
    
    // https://stackoverflow.com/questions/58470229/how-to-draw-a-line-between-two-points-in-scenekit
    private func addConnections(to scene: SCNScene, _ atom: Atom) {
        for connection in atom.connections {
            let from = SCNVector3(x: atom.x, y: atom.y, z: atom.z)
            let to = getAtomCoordinates(for: connection)
            
            let dx = to.x - from.x
            let dy = to.y - from.y
            let dz = to.z - from.z
            let distance = sqrtf(dx * dx + dy * dy + dz * dz)
            
            let cylinder = SCNCylinder(radius: 0.05, height: CGFloat(distance))
            cylinder.firstMaterial?.diffuse.contents = UIColor.gray
            
            let lineNode = SCNNode(geometry: cylinder)
            lineNode.position = SCNVector3(x: (from.x + to.x) / 2, y: (from.y + to.y) / 2, z: (from.z + to.z) / 2)
            
            lineNode.look(at: to, up: scene.rootNode.worldUp, localFront: lineNode.worldUp)
            
            scene.rootNode.addChildNode(lineNode)
        }
    }
    
    // https://stackoverflow.com/questions/21544336/how-to-position-the-camera-so-that-my-main-object-is-entirely-visible-and-fit-to
    // https://forum.unity.com/threads/fit-object-exactly-into-perspective-cameras-field-of-view-focus-the-object.496472/
    private func addCamera(to scene: SCNScene, coordinator: Coordinator) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        let cameraPosition = coordinator.computeCameraPosition()
        cameraNode.position = cameraPosition
        
        scene.rootNode.addChildNode(cameraNode)
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
