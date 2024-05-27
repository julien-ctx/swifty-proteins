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
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ProteinListView()
            } else {
                LoginView(viewModel: LoginViewModel(), isAuthenticated: $isAuthenticated)
            }
        }
        .onChange(of: scenePhase) { newPhase, _ in
            if newPhase == .active {
                isAuthenticated = false
            }
        }
    }
}
