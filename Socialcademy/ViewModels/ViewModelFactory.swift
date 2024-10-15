//
//  ViewModelFactory.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 15.10.24.
//

import SwiftUI

/// use to supply views with their dependencies
@MainActor
class ViewModelFactory: ObservableObject {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func makePostsViewModel(filter: PostsViewModel.Filter = .all) -> PostsViewModel {
        return PostsViewModel(filter: filter, postsRepository: PostsRepository(user: user))
    }
}

#if DEBUG
extension ViewModelFactory {
    static let preview = ViewModelFactory(user: User.testUser)
}
#endif
