//
//  Comment.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 17.10.24.
//

import Foundation
import FirebaseFirestore

struct Comment: Identifiable, Equatable, Codable {
    var content: String
    var author: User
    var timestamp = Date()
    var id = UUID()
}

extension Comment {
    static let testComment = Comment(content: "Lorem ipsum dolor set amet.", author: User.testUser)
}
