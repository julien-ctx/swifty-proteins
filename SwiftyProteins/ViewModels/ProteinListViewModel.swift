//
//  ProteinListViewModel.swift
//  SwiftyProteins
//
//  Created by Minguk on 22/05/2024.
//

import Foundation
import Combine

class ProteinListViewModel: ObservableObject {
    @Published var proteinTypes: [String] = []

    init() {
        loadProteinTypes()
    }

    func loadProteinTypes() {
        if let path = Bundle.main.path(forResource: "ligand", ofType: "txt") {
            do {
                let content = try String(contentsOfFile: path, encoding: .utf8)
                let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
                self.proteinTypes = lines
            } catch {
                print("Error loading ligand.txt: \(error)")
            }
        }
    }
}
