//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 04.10.24.
//

import SwiftUI

struct NewPostForm: View {
    
    @StateObject var viewModel: FormViewModel<Post>
    @Environment(\.dismiss) private var dismiss

    ///One interesting implementation detail is that the DismissAction isn’t a function, but rather a callable type. This feature, added in Swift 5.2, allows types to be called as functions when they implement a callAsFunction method. This means dismiss() is actually syntactic sugar for dismiss.callAsFunction().
        
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $viewModel.title)
                }
                ImageSection(imageURL: $viewModel.imageURL)
                Section("Content") {
                    TextEditor(text: $viewModel.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
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
            .onSubmit(viewModel.submit)
            .navigationTitle("New Post")
            .onChange(of: viewModel.isWorking) { isWorking in
                guard !isWorking, viewModel.error == nil else { return }
                dismiss()
            }
        }
        .disabled(viewModel.isWorking)
        .alert("Cannot Create Post", error: $viewModel.error)
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

struct NewPostForm_Previews: PreviewProvider {
    static var previews: some View {
        NewPostForm(viewModel: FormViewModel(initialValue: Post.testPost, action: { _ in }))
    }
}

private extension NewPostForm {
    struct ImageSection: View {
        @Binding var imageURL: URL?
        
        var body: some View {
            Section("Image") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    EmptyView()
                }
                ImagePickerButton(imageURL: $imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
            }
        }
    }
}
