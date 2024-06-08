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
    @Binding var viewList: ViewList
    @ObservedObject var viewModel = CreateAccountViewModel()
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case username
        case password
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                TextField("Username", text: $viewModel.username)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 1)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .username)
                
                SecureField("Password", text: $viewModel.password)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .password)
                
                
                if geometry.size.width > geometry.size.height {
                    HStack {
                        FaceIDToggle(isOn: $viewModel.useBiometrics)
                        CreateAccountButton(viewModel: viewModel, viewList: $viewList)
                        BackToLogin(viewList: $viewList)
                    }
                    .padding()
                } else {
                    VStack {
                        FaceIDToggle(isOn: $viewModel.useBiometrics)
                        CreateAccountButton(viewModel: viewModel, viewList: $viewList)
                        BackToLogin(viewList: $viewList)
                    }
                    .padding()
                }
                Spacer()
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
}

struct FaceIDToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text("Use Touch ID / Face ID")
        }
        .padding()
    }
}

struct CreateAccountButton: View {
    @ObservedObject var viewModel: CreateAccountViewModel
    @Binding var viewList: ViewList
    
    var body: some View {
        Button(action: {
            if viewModel.createUser() {
                viewList = .Login
            }
        }) {
            Text("Create Account")
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct BackToLogin: View {
    @Binding var viewList: ViewList
    
    var body: some View {
        Button(action: {
            viewList = ViewList.Login
        }) {
            Text("Back to login")
                .padding()
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(viewList: .constant(ViewList.CreateAccount))
    }
}
