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
    
    @StateObject private var proteinViewModel = ProteinViewModel()
    @State private var proteinImage: UIImage?
    @State private var shareURL: URL?
    
    var body: some View {
        VStack {
            if proteinViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle()).scaleEffect(3)
            } else if let error = proteinViewModel.error {
                ProteinErrorView(error: error)
            } else if let molecule = proteinViewModel.molecule {
                MoleculeView(molecule: molecule, onImageGenerated: { image in
                    proteinImage = image
                })
            } else {
                Text("No data to display")
                    .padding()
            }
        }
        .toolbarBackground(Color(white: 0.95), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle(proteinType)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Group {
                    if proteinViewModel.molecule != nil, let image = proteinImage {
                        Button(action: {
                            shareProteinImage(image: image, proteinType: proteinType)
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    } else if proteinViewModel.error == nil {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }
        }
        .onAppear {
            proteinViewModel.getProteinData(for: proteinType) { success in
                if success {
                    proteinViewModel.getMolecule()
                }
            }
        }
    }
}

func shareProteinImage(image: UIImage, proteinType: String) {
    let message = "Look at protein \(proteinType)"
    let activityViewController = UIActivityViewController(activityItems: [message, image], applicationActivities: nil)
    
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let topController = scene.windows.first?.rootViewController {
        activityViewController.popoverPresentationController?.sourceView = topController.view
        topController.present(activityViewController, animated: true)
    }
}

struct ProteinView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinView(proteinType: "Sample Protein")
    }
}
