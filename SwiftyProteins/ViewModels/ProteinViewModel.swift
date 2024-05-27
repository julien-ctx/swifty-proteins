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
            print("Protein name is empty")
            self.error = "Invalid protein name"
            self.isLoading = false
            completion(false)
            return
        }
        
        let urlString = "https://files.rcsb.org/ligands/\(firstProteinChar)/\(protein)/\(protein)_ideal.pdb"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("Error while creating URL")
            self.error = "Invalid URL"
            self.isLoading = false
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Error while retrieving data from RCSB website: \(error.localizedDescription)")
                    self.error = "Failed to retrieve data"
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("Error: No data received")
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
            print("Failed to parse PDB file")
            self.error = "Invalid PDB file"
            return
        }
        do {
            molecule = try pdbParser.parsePDB(content: pdbContent)
        } catch let error as PDBParser.PDBParserError {
            switch error {
            case .InvalidRecordName:
                print("InvalidRecordName")
            case .InvalidAtomLine:
                print("InvalidAtomLine")
            case .InvalidConectLine:
                print("InvalidConectLine")
            }
        } catch {
            print("An unexpected error occurred")
        }
    }
}
