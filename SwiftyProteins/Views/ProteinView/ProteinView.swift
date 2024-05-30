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
    @State private var showingSettings = false
    
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
                MoleculeView(molecule: molecule, onError: viewModel.onError(_:))
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
                HStack {
                    Button(action: {
                        viewModel.shareProtein()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(recenterAction: {
                print("lol")
            })                }
        .onAppear {
            viewModel.getProteinData(for: proteinType) { success in
                if success {
                    viewModel.getMolecule()
                    
                }
            }
        }
        
    }
}

struct SettingsView: View {
    var recenterAction: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Button(action: recenterAction) {
                    Text("Recenter Protein")
                }
                // Add more options here as needed
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        // Logic to dismiss the modal
                    }
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
