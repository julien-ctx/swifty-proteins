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
            }
        } catch {
            self.error = "Something unexpected happened"
        }
    }
}
