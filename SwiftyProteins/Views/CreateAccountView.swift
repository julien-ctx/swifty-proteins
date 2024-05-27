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
            
            Button(action: {
                viewModel.createUser()
                if !viewModel.showError {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Create Account")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            if viewModel.showError {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
