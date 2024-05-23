//
//  SwiftyProteinsApp.swift
//  SwiftyProteins
//
//  Created by Julien Caucheteux on 18/05/2024.
//

import SwiftUI

@main
struct SwiftyProteinsApp: App {
    @State private var isAuthenticated: Bool = false

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ProteinListView()
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
