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

    func createUser() {
        if !validateUsername() {
            showAlert = true
            alertTitle = "Invalid Username"
            alertMessage = "Username must be 4-20 characters long and can contain letters, numbers, '-' or '_'. It cannot start with '-' or '_'."
            return
        }
        
        if !validatePassword() {
            showAlert = true
            alertTitle = "Invalid Password"
            alertMessage = "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number."
            return
        }
        
        if SQLiteManager.shared.addUser(username: username, password: password) {
            // Store biometric preference (this example uses UserDefaults for simplicity)
            UserDefaults.standard.set(useBiometrics, forKey: "\(username)_biometrics")
        } else {
            showAlert = true
            alertTitle = "Account Creation Failed"
            alertMessage = "Failed to create account. Username might already be taken."
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
        if password.count < 8 {
            alertMessage = "Password must be at least 8 characters long."
            return false
        }

        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
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
