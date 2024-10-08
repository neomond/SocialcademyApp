//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 05.10.24.
//

import Foundation
import FirebaseFirestore

// MARK: - PostsRepositoryProtocol

protocol PostsRepositoryProtocol {
    func fetchAllPosts() async throws -> [Post]
    func fetchFavoritePosts() async throws -> [Post]

    func create(_ post: Post) async throws
    func delete(_ post: Post) async throws
    
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
}


// MARK: - PostsRepositoryStub

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    let state: Loadable<[Post]>
    
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func create(_ post: Post) async throws {}
    func delete(_ post: Post) async throws {}
    
    func favorite(_ post: Post) async throws {}
    func unfavorite(_ post: Post) async throws {}
}
#endif


// MARK: - PostsRepository

struct PostsRepository: PostsRepositoryProtocol {
    let postsReference = Firestore.firestore().collection("posts_v1") /// version number
    
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let snapshot = try await query
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
    }
    
    func fetchAllPosts() async throws -> [Post] {
//        let snapshot = try await postsReference
//            .order(by: "timestamp", descending: true)
//            .getDocuments()
//        return snapshot.documents.compactMap { document in
//            try! document.data(as: Post.self)
//        }
        return try await fetchPosts(from: postsReference)
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
//        let snapshot = try await postsReference
//            .order(by: "timestamp", descending: true)
//            .whereField("isFavorite", isEqualTo: true).getDocuments()
//       return snapshot.documents.compactMap { document in
//            try! document.data(as: Post.self)
//        }
        return try await fetchPosts(from: postsReference.whereField("isFavorite", isEqualTo: true))
    }
    
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    func delete(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    
    func favorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": true], merge: true)
    }
    
    func unfavorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": false], merge: true)
    }
    
    /// This obtains a document reference for the given post and uses the setData(_:merge:) method to set the isFavorite property.
    /// Typically, the setData(_:) method overwrites the document with the given data. By setting the merge parameter to true, we’re telling Cloud Firestore to merge the given data into an existing document instead of overwriting the document entirely.
}

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
