import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @Binding var isAuthenticated: Bool
    @State private var showCreateAccount: Bool = false

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
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
            
            if viewModel.useBiometrics {
                Button(action: {
                    viewModel.authenticateWithBiometrics()
                }) {
                    Text("Use Touch ID / Face ID")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
           
            Button(action: {
                showCreateAccount.toggle()
            }) {
                Text("Create Account")
                    .padding()
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .sheet(isPresented: $showCreateAccount) {
            CreateAccountView()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Authentication Failed"), message: Text("The username or password you entered is incorrect."), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            viewModel.authenticateWithBiometrics()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(), isAuthenticated: .constant(false))
    }
}
