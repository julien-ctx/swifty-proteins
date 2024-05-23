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
            List(viewModel.proteinTypes, id: \.self) { protein in
                NavigationLink(destination: ProteinView(proteinType: protein)) {
                    Text(protein)
                }
            }
            .navigationTitle("Proteins")
        }
    }
}

struct ProteinListView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinListView()
    }
}
