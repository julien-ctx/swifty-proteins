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
    
    func getProteinData(for protein: String) {
        self.isLoading = true
//        let urlString = "https://files.rcsb.org/ligands/view/\(protein.uppercased())_model.sdf"
        
        guard let firstProteinChar = protein.first else {
            print("Protein name is empty")
            self.error = "Invalid protein name"
            self.isLoading = false
            return
        }
        
        let urlString = "https://files.rcsb.org/ligands/\(firstProteinChar)/\(protein)/\(protein)_ideal.pdb"

        guard let url = URL(string: urlString) else {
            print("Error while creating URL")
            self.error = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Error while retrieving data from RCSB website: \(error.localizedDescription)")
                    self.error = "Failed to retrieve data"
                    return
                }
                
                guard let data = data else {
                    print("Error: No data received")
                    self.error = "No data received"
                    return
                }
                
                self.pdbContent = String(data: data, encoding: .utf8)
            }
        }.resume()
    }
}
