//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 04.10.24.
//

import SwiftUI

struct NewPostForm: View {
    
    typealias CreateAction = (Post) async throws -> Void /// The CreateAction is a function that takes a Post object as a parameter. We’ll use this to upload posts to Firebase and update surrounding views.
    
    @State private var post = Post(title: "", content: "", authorName: "")
    @Environment(\.dismiss) private var dismiss
    
    @State private var state = FormState.idle
    
    
    ///One interesting implementation detail is that the DismissAction isn’t a function, but rather a callable type. This feature, added in Swift 5.2, allows types to be called as functions when they implement a callAsFunction method. This means dismiss() is actually syntactic sugar for dismiss.callAsFunction().
    
    let createAction: CreateAction
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $post.title)
                    TextField("Author Name", text: $post.authorName)
                }
                Section("Content") {
                    TextEditor(text: $post.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: createPost) {
                    if state == .working {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
                
            }
            .onSubmit(createPost)
            .navigationTitle("New Post")
        }
        .disabled(state == .working)
        .alert("Cannot Create Post", isPresented: $state.isError, actions: {}){
            Text("Sorry, something went wrong.")
        }
        
    }
    
    private func createPost() {
        Task {
            state = .working
            do {
                try await createAction(post)
                dismiss()
            } catch {
                print("[NewPostForm] Cannot create post: \(error)")
                state = .error
            }
            
        }
    }
}


// MARK: - FormState

private extension NewPostForm {
    enum FormState {
        case idle, working, error
        
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else { return }
                self = .idle
            }
        }
    }
}
/// Here, we’ve added an isError property, which is true when the current FormState is error. We declared both a getter and a setter because this is required to create a two-way binding. When the user dismisses the alert, SwiftUI will set isError to false, causing the FormState to revert to idle.

#Preview {
    NewPostForm(createAction: { _ in })
}
