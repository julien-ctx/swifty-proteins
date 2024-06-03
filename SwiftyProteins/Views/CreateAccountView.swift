//
//  CreateAccountView.swift
//  SwiftyProteins
//
//  Created by Minguk on 27/05/2024.
//

import Foundation
import SwiftUI

struct CreateAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = CreateAccountViewModel()
    @Binding var showCreateAccount: Bool

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding(.horizontal, 16)
                .padding(.vertical, 1)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $viewModel.password)
                .padding(.horizontal, 16)
                .padding(.vertical, 1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Toggle(isOn: $viewModel.useBiometrics) {
                Text("Use Touch ID / Face ID")
            }
            .padding()
            
            Button(action: {
                if viewModel.createUser() {
                    showCreateAccount = false
                }
            }) {
                Text("Create Account")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(showCreateAccount: .constant(false))
    }
}
