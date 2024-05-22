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

    var body: some View {
        VStack {
            Text("3D Rendering for Protein: \(proteinType)")
                .padding()
            // Add 3D rendering code here
        }
        .navigationTitle(proteinType)
    }
}

struct ProteinView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinView(proteinType: "Sample Protein")
    }
}
