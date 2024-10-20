//
//  User.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 15.10.24.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
    var imageURL: URL?
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris", imageURL: URL(string: "https://source.unsplash.com/lw9LrnpUmWw/480x480"))
}
