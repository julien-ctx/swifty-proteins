//
//  LoginViewModel.swift
//  SwiftyProteins
//
//  Created by Minguk on 27/05/2024.
//

import Foundation
import LocalAuthentication

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var showError: Bool = false

    func authenticateUser() {
        if SQLiteManager.shared.verifyUser(username: username, password: password) {
            isAuthenticated = true
        } else {
            showError = true
        }
    }
    
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in to your account") { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        // Biometrics failed, fallback to password login
                    }
                }
            }
        }
    }
}
