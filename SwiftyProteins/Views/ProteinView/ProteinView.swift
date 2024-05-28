//
//  ProteinViewController.swift
//  SwiftyProteins
//
//  Created by Minguk on 21/05/2024.
//

import Foundation
import SwiftUI

struct ProteinView: View {
    let proteinType: String
    
    @StateObject private var viewModel = ProteinViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle()).scaleEffect(3)
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if let molecule = viewModel.molecule {
                MoleculeView(molecule: molecule)
                    .frame(width: 400, height: 400)
            } else {
                Text("No data to display")
                    .padding()
            }
        }
        .navigationTitle(proteinType)
        .onAppear {
            viewModel.getProteinData(for: proteinType) { success in
                if success {
                    viewModel.getMolecule()
                }
            }
        }
        
    }
}

struct ProteinView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinView(proteinType: "Sample Protein")
    }
}
