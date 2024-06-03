//
//  CreateAccountViewModel.swift
//  SwiftyProteins
//
//  Created by Minguk on 27/05/2024.
//

import Foundation
import LocalAuthentication

class CreateAccountViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var useBiometrics: Bool = false {
        didSet {
            if useBiometrics {
                checkBiometricAvailability()
            }
        }
    }
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    func createUser() -> Bool {
        if !validateUsername() {
            showAlert = true
            alertTitle = "Invalid Username"
            return false
        }
        
        if !validatePassword() {
            showAlert = true
            alertTitle = "Invalid Password"
            return false
        }
        
        if SQLiteManager.shared.addUser(username: username, password: password, useBiometrics: useBiometrics) {
            return true
        } else {
            showAlert = true
            alertTitle = "Account Creation Failed"
            alertMessage = "Failed to create account. Username might already be taken."
            return false
        }
    }
    
    private func validateUsername() -> Bool {
        let regex = "^[A-Za-z0-9][A-Za-z0-9_-]{3,19}$"
        if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: username) {
            return true
        } else {
            alertMessage = "Username must be 4-20 characters long and can contain letters, numbers, '-' or '_'. It cannot start with '-' or '_'."
            return false
        }
    }

    private func validatePassword() -> Bool {
        if password.count < 4 {
            alertMessage = "Password must be at least 4 characters long."
            return false
        }

        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{4,}$"
        if NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
            return true
        } else {
            alertMessage = "Password must contain at least one uppercase letter, one lowercase letter, and one number."
            return false
        }
    }
    
    private func checkBiometricAvailability() {
        let context = LAContext()
        var error: NSError?

        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            showAlert = true
            alertTitle = "Biometric Authentication Not Available"
            alertMessage = "Biometric authentication is not available on this device."
            useBiometrics = false
        }
    }
}
