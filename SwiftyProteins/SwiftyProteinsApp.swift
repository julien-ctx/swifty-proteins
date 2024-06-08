//
//  SwiftyProteinsApp.swift
//  SwiftyProteins
//
//  Created by Julien Caucheteux on 18/05/2024.
//

import SwiftUI

enum ViewList: Int {
    case ProteinList = 0
    case Login = 1
    case CreateAccount = 2
}

@main
struct SwiftyProteinsApp: App {
    @State private var viewList: ViewList = ViewList.Login
    @State private var showSplashScreen: Bool = true
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            showSplashScreen = false
                        }
                    }
            } else {
                if viewList == ViewList.ProteinList {
                    ProteinListView()
                } else if viewList == ViewList.Login {
                    LoginView(viewModel: LoginViewModel(), viewList: $viewList)
                } else {
                    CreateAccountView(viewList: $viewList)
                }
            }
        }
        .onChange(of: scenePhase) { newPhase, _ in
            if newPhase == .active {
                viewList = ViewList.Login
            }
        }
    }
}
