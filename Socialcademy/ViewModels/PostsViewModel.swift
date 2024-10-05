//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 04.10.24.
//

import SwiftUI

@MainActor
class PostsViewModel: ObservableObject {
    
    @Published var posts: Loadable<[Post]> = .loading
    
    private let postsRepository: PostsRepositoryProtocol
    
    init(postsRepository: PostsRepositoryProtocol = PostsRepository()) {
        self.postsRepository = postsRepository
    }
    
    func fetchPosts() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts())
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            try await self?.postsRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        }
    }
}

