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
    @State private var showingSettings = false
    
    var body: some View {
        VStack {
            if proteinViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle()).scaleEffect(3)
            } else if let error = proteinViewModel.error {
               ProteinErrorView(error: error)
            } else if let molecule = proteinViewModel.molecule {
                MoleculeView(molecule: molecule)
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
                        proteinViewModel.shareProtein()
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
            }, showSettings: $showingSettings).presentationDetents([.medium])
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

struct ProteinView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinView(proteinType: "Sample Protein")
    }
}
