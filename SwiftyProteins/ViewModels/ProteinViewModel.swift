//
//  ProteinViewModel.swift
//  SwiftyProteins
//
//  Created by Julien Caucheteux on 26/05/2024.
//

import Foundation

class ProteinViewModel: ObservableObject {
    @Published var pdbContent: String? = nil
    @Published var isLoading: Bool = true
    @Published var error: String? = nil
    @Published var molecule: Molecule? = nil
    
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
    
    func getProteinData(for protein: String, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        
        guard let firstProteinChar = protein.first else {
            self.error = "Invalid protein name"
            self.isLoading = false
            completion(false)
            return
        }
        
        let urlString = "https://files.rcsb.org/ligands/\(firstProteinChar)/\(protein)/\(protein)_ideal.pdb"
        guard let url = URL(string: urlString) else {
            self.error = "Invalid URL"
            self.isLoading = false
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let _ = error {
                    self.error = "Failed to retrieve data"
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    self.error = "No data received"
                    completion(false)
                    return
                }
                
                self.pdbContent = String(data: data, encoding: .utf8)
                completion(true)
            }
        }.resume()
    }
    
    
    func getMolecule() -> Void {
        let pdbParser = PDBParser()
        guard let pdbContent = pdbContent else {
            self.error = "Invalid PDB file"
            return
        }
        do {
            molecule = try pdbParser.parsePDB(content: pdbContent)
        } catch let error as PDBParser.PDBParserError {
            switch error {
            case .InvalidRecordName:
                self.error = "Invalid record name in file"
            case .InvalidAtomLine:
                self.error = "Invalid ATOM line in file"
            case .InvalidConectLine:
                self.error = "Invalid ATOM CONECT line in file"
            case .InvalidAtomNumber:
                self.error = "No atom found in protein"
            }
        } catch {
            self.error = "Something unexpected happened"
        }
    }
    
    func onError(_ currentError: String) -> Void {
        error = currentError
    }
    
    func shareProtein() -> Void {
        
    }
}
