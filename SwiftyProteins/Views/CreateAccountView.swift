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

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Toggle(isOn: $viewModel.useBiometrics) {
                Text("Use Touch ID / Face ID")
            }
            .padding()
            
            Button(action: {
                viewModel.createUser()
            }) {
                Text("Create Account")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

        }
        .padding()
        .navigationBarTitle("Create Account", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.blue)
                .padding()
        })
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
        CreateAccountView()
    }
}
