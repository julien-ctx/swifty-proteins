//
//  CreateAccountViewModel.swift
//  SwiftyProteins
//
//  Created by Minguk on 27/05/2024.
//

import Foundation

class CreateAccountViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    func createUser() {
        if SQLiteManager.shared.addUser(username: username, password: password) {
            // User created successfully
        } else {
            showError = true
            errorMessage = "Failed to create account. Username might already be taken."
        }
    }
}
