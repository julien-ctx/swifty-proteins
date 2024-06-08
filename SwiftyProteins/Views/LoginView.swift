import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @Binding var viewList: ViewList
    @State private var showPasswordFields: Bool = false
    @FocusState private var focusedField: Field? // Define a focus state

    enum Field: Hashable {
        case username
        case password
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                VStack {
                    UsernameField(viewModel: viewModel, focusedField: $focusedField)
                    PasswordField(viewModel: viewModel, viewList: $viewList, focusedField: $focusedField)
                }
                
                if geometry.size.width > geometry.size.height {
                    HStack {
                        LoginButton(viewModel: viewModel, viewList: $viewList)
                        FaceIDButton(viewModel: viewModel, viewList: $viewList)
                        CreateAccount(viewList: $viewList)
                    }
                    .padding()
                } else {
                    VStack {
                        LoginButton(viewModel: viewModel, viewList: $viewList)
                        FaceIDButton(viewModel: viewModel, viewList: $viewList)
                        CreateAccount(viewList: $viewList)
                    }
                    .padding()
                }
                Spacer()
                
            }
            .padding()
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text(viewModel.errorTitle), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct UsernameField: View {
    @ObservedObject var viewModel: LoginViewModel
    @FocusState.Binding var focusedField: LoginView.Field?

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding(.horizontal, 16)
                .padding(.vertical, 1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .transition(.move(edge: .leading))
                .focused($focusedField, equals: .username)
        }
    }
}

struct PasswordField: View {
    @ObservedObject var viewModel: LoginViewModel
    @Binding var viewList: ViewList
    @FocusState.Binding var focusedField: LoginView.Field?

    var body: some View {
        VStack {
            SecureField("Password", text: $viewModel.password)
                .padding(.horizontal, 16)
                .padding(.vertical, 1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .transition(.move(edge: .trailing))
                .focused($focusedField, equals: .password)
        }
    }
}

struct LoginButton: View {
    @ObservedObject var viewModel: LoginViewModel
    @Binding var viewList: ViewList

    var body: some View {
        Button(action: {
            Task {
                let usernameRes = viewModel.checkUsername()
                if !usernameRes {
                    return
                }
                await viewModel.authenticateUser()
                viewList = viewModel.viewList
            }
        }) {
            Text("Login")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .transition(.move(edge: .trailing))
    }
}

struct FaceIDButton: View {
    @ObservedObject var viewModel: LoginViewModel
    @Binding var viewList: ViewList

    var body: some View {
        Button(action: {
            Task {
                let usernameRes = viewModel.checkUsername()
                if !usernameRes {
                    return
                }
                let success = await viewModel.authenticateWithBiometrics()
                if success {
                    viewList = ViewList.ProteinList
                }
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

struct CreateAccount: View {
    @Binding var viewList: ViewList
    
    var body: some View {
        Button(action: {
            viewList = ViewList.CreateAccount
        }) {
            Text("Create Account")
                .padding()
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(), viewList: .constant(ViewList.Login))
    }
}
