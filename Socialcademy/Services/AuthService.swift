//
//  AuthService.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 14.10.24.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    
    private let auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle?
    
    init() {
        listener = auth.addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
        }
    }
    
    /// create acc, sing in, sign out the user
    func createAccount(name: String, email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        try await result.user.updateProfile(\.displayName, to: name)
    }
    
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    
    func signOut() throws {
        try auth.signOut()
    }
}


/// This defines the AuthService with an isAuthenticated property, which is kept up to date by the authentication state change listener in the init method.
/// The auth property stores the Firebase Auth instance, while the listener property keeps a strong reference to the state change listener so it doesn’t get deallocated.


private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}
