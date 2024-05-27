//
//  ProteinListViewController.swift
//  SwiftyProteins
//
//  Created by Minguk on 21/05/2024.
//

import Foundation
import SwiftUI

struct ProteinListView: View {
    @StateObject private var viewModel = ProteinListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Proteins", text: $viewModel.searchQuery)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing])
                    .onChange(of: viewModel.searchQuery) { _, _ in
                        viewModel.filterProteins()
                    }

                List(viewModel.filteredProteinTypes, id: \.self) { protein in
                    NavigationLink(destination: ProteinView(proteinType: protein)) {
                        Text(protein)
                    }
                }
            }.navigationTitle("Proteins")
        }
    }
}

struct ProteinListView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinListView()
    }
}
