//
//  AuthViewModel.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 14.10.24.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var user: User?
    
    private let authService = AuthService()
    
    init() {
        authService.$user.assign(to: &$user)
    }
    
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(action: authService.signIn(email:password:))
    }

    func makeCreateAccountViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(action: authService.createAccount(name:email:password:))
    }
}

/// This defines the AuthViewModel with an isAuthenticated property.
/// When a property includes the Published property wrapper, we can forward its value and any updates to another Published property by using the assign(to:) method and referencing both properties with a $ in front of their names.
/// We used this in the initializer to ensure the isAuthenticated property of our view model matches that of the AuthService. This way, we can update the AuthView when the authentication state changes.


extension AuthViewModel {
    class SignInViewModel: FormViewModel<(email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (email: "", password: ""), action: action)
        }
    }
    
    class CreateAccountViewModel: FormViewModel<(name: String, email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (name: "", email: "", password: ""), action: action)
        }
    }
}
