//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 04.10.24.
//

import SwiftUI

@MainActor
class PostsViewModel: ObservableObject {
    
    @Published var posts = [Post.testPost]
    
    func makeCreateAction() -> NewPostForm.CreateAction { /// factory function
        return { [weak self] post in
            try await PostsRepository.create(post)
            self?.posts.insert(post, at: 0)
        }
    }
}
