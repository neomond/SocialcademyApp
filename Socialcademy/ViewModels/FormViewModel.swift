//
//  FormViewModel.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 14.10.24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class FormViewModel<Value>: ObservableObject, StateManager {
    typealias Action = (Value) async throws -> Void
    
    @Published var value: Value
    @Published var error: Error?
    @Published var isWorking = false
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
    
    private let action: Action
    
    init(initialValue: Value, action: @escaping Action) {
        self.value = initialValue
        self.action = action
    }
    
    private func handleSubmit() async {
        isWorking = true
        do {
            try await action(value)
        } catch {
            print("[FormViewModel] Cannot submit: \(error)")
            self.error = error
        }
        isWorking = false
    }


    /// nonisolated is called synchronously without awaiting, as it doesn’t interact with the actor’s isolated state.
    nonisolated func submit() {
        withStateManagingTask { [self] in
            try await action(value)
        }
    }
}
