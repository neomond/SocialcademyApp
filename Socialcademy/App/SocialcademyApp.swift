//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 04.10.24.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
           PostsList()
        }
    }
}
