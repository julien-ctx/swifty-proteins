//
//  LoginViewController.swift
//  SwiftyProteins
//
//  Created by Minguk on 21/05/2024.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                authenticateUser()
            }) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            if showError {
                Text("Authentication Failed")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
    
    func authenticateUser() {
        // Placeholder for actual authentication logic
        if username == "Test" && password == "password" {
            isAuthenticated = true
        } else {
            showError = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isAuthenticated: .constant(false))
    }
}

