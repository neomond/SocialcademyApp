//
//  Post.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 04.10.24.
//

import Foundation

struct Post: Identifiable, Codable, Equatable {  /// useful for List or ForEach to display a list of posts and will be indispensable as we add more complex features to our app.
    var title: String
    var content: String
    var authorName: String
    var timestamp = Date()
    var isFavorite = false
    var id = UUID()
    
    
    func contains(_ string: String) -> Bool {
        let properties = [title, content, authorName].map { $0.lowercased() }
        
        let query = string.lowercased()
        
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
}


extension Post {
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        authorName: "Nazrin Atayeva"
    )
}
