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
    @Published var viewList: ViewList = ViewList.Login
    @Published var showError: Bool = false
    @Published var errorTitle: String = ""
    @Published var errorMessage: String = ""
    @Published var isUsernameValid: Bool = false
        
    private let context = LAContext()
    private var error: NSError?
    
    func setError(_ title: String, _ message: String) {
        DispatchQueue.main.async {
            self.showError = true
            self.errorTitle = title
            self.errorMessage = message
        }
    }
    
    func authenticateUser() {
        if password.isEmpty {
            self.setError("Login Error", "The password is required.")
            return
        }
        
        if SQLiteManager.shared.verifyUser(username: username, password: password) {
            DispatchQueue.main.async {
                self.viewList = ViewList.ProteinList
            }
        } else {
            self.setError("Authentication Failed", "The username or password you entered is incorrect.")
        }
    }
    
    func authenticateWithBiometrics() async -> Bool {
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.setError("Biometric Authentication Failed", "Your device doesn't support Face ID.")
            return false
        }
        if !SQLiteManager.shared.userExistsWithBiometrics(username: self.username) {
            self.setError("Face ID Error", "This user cannot be authenticated with Face ID.")
            return false
        }
        return await withCheckedContinuation { continuation in
            self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login to your account.") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.viewList = ViewList.ProteinList
                        continuation.resume(returning: true)
                    } else {
                        self.setError("Authentication Failed", "Biometric authentication failed. Please try again.")
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }

    func checkUsername() -> Bool {
        if username.isEmpty {
            self.setError("Login Error", "The username is required.")
            return false
        } else if username.count < 4 || username.count > 20 {
            self.setError("Login Error", "The username must be between 4-20 letters.")
            return false
        } else {
            DispatchQueue.main.async {
                self.isUsernameValid = true
            }
            return true
        }
    }
}
