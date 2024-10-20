//
//  CommentRowViewModel.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 17.10.24.
//

import SwiftUI

@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject, StateManager {
    @Published var comment: Comment
    @Published var error: Error?

    typealias Action = () async throws -> Void
    private let deleteAction: Action?

    var canDeleteComment: Bool { deleteAction != nil }

    subscript<T>(dynamicMember keyPath: KeyPath<Comment, T>) -> T {
        comment[keyPath: keyPath]
    }
    
    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }
    
    func deleteComment() {
        guard let deleteAction = deleteAction else {
              preconditionFailure("Cannot delete comment: no delete action provided")
          }
          withStateManagingTask(perform: deleteAction)
    }
}
