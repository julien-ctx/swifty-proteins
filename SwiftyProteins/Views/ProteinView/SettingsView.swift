//
//  SettingsView.swift
//  SwiftyProteins
//
//  Created by Julien Caucheteux on 01/06/2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var recenterAction: () -> Void
    @Binding var showSettings: Bool
    
    var body: some View {
        NavigationView {
            List {
                Button(action: recenterAction) {
                    Label("Center protein", systemImage: "arrow.right.and.line.vertical.and.arrow.left")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        showSettings.toggle()
                    }
                }
            }
        }
    }
}
