import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @Binding var isAuthenticated: Bool
    @State private var showCreateAccount: Bool = false
    @State private var showPasswordFields: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                if showPasswordFields {
                    VStack {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showPasswordFields = false
                                    viewModel.isUsernameValid = false
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                    .padding()
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .transition(.opacity)

                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .transition(.move(edge: .trailing))

                        Button(action: {
                            viewModel.authenticateUser()
                            isAuthenticated = viewModel.isAuthenticated
                        }) {
                            Text("Login")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .transition(.move(edge: .trailing))

                        if viewModel.useBiometrics {
                            Button(action: {
                                Task {
                                    let success = await viewModel.authenticateWithBiometrics()
                                    isAuthenticated = success
                                }
                            }) {
                                Text("Use Touch ID / Face ID")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .transition(.move(edge: .trailing))
                        }
                    }
                    Spacer()
                } else {
                    VStack {
                        TextField("Username", text: $viewModel.username, onCommit: {
                            viewModel.checkUsername()
                            withAnimation {
                                showPasswordFields = viewModel.isUsernameValid
                            }
                        })
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .transition(.move(edge: .leading))

                        Button(action: {
                            viewModel.checkUsername()
                            withAnimation {
                                showPasswordFields = viewModel.isUsernameValid
                            }
                        }) {
                            Text("Next")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .transition(.move(edge: .leading))
                    }
                    
                    Spacer()

                    Button(action: {
                        showCreateAccount.toggle()
                    }) {
                        Text("Create Account")
                            .padding()
                            .foregroundColor(.blue)
                    }
                }

            }
            .padding()
            .sheet(isPresented: $showCreateAccount) {
                CreateAccountView(showCreateAccount: $showCreateAccount)
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text(viewModel.errorTitle), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(), isAuthenticated: .constant(false))
    }
}
