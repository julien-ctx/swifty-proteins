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
    @Published var errorTitle: String = ""
    @Published var errorMessage: String = ""
    @Published var useBiometrics: Bool = false
    @Published var isUsernameValid: Bool = false
        
    private let context = LAContext()
    private var error: NSError?

    init() {
        checkBiometricAvailability()
    }
    
    func setError(_ title: String, _ message: String) {
        showError = true
        errorTitle = title
        errorMessage = message
    }
    
    func authenticateUser() {
        if password.isEmpty {
            self.setError("Login Error", "The password is required.")
            return
        }
        
        if SQLiteManager.shared.verifyUser(username: username, password: password) {
            isAuthenticated = true
        } else {
            self.setError("Authentication Failed", "The username or password you entered is incorrect.")
        }
    }
    
    func authenticateWithBiometrics() async -> Bool {
        if !SQLiteManager.shared.userExistsWithBiometrics(username: self.username) {
            self.setError("Face ID Error", "This user cannot be authenticated with Face ID.")
            return false
        }
        return await withCheckedContinuation { continuation in
            self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login to your account.") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("allo???")
                        self.isAuthenticated = true
                        continuation.resume(returning: true)
                    } else {
                        self.setError("Face ID Failed", "Biometric authentication failed. Please try again.")
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }

    func checkUsername() {
        if username.isEmpty {
            self.setError("Login Error", "The username is required.")
        } else if username.count < 4 || username.count > 20 {
            self.setError("Login Error", "The username must be between 4-20 letters.")
        } else {
            self.isUsernameValid = true
        }
    }
    
    private func checkBiometricAvailability() {
        
        if self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.useBiometrics = true
        } else {
            self.useBiometrics = false
        }
    }
}
