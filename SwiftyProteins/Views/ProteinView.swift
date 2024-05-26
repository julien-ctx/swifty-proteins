//
//  ProteinViewController.swift
//  SwiftyProteins
//
//  Created by Minguk on 21/05/2024.
//

import Foundation
import SwiftUI

struct ProteinView: View {
    var proteinType: String
    
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
                } else if let pdbContent = viewModel.pdbContent {
                    Text("3D Rendering for Protein: \(proteinType)")
                        .padding()
                    ScrollView {
                        Text(pdbContent)
                            .padding()
                    }
                } else {
                    Text("No data to display")
                        .padding()
                }
            }
            .navigationTitle(proteinType)
            .onAppear {
                viewModel.getProteinData(for: proteinType)
            }
        }
}

struct ProteinView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinView(proteinType: "Sample Protein")
    }
}
