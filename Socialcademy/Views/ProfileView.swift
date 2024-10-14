//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 14.10.24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Button("Sign Out", action: {
            try! Auth.auth().signOut()
        })
    }}

#Preview {
    ProfileView()
}
