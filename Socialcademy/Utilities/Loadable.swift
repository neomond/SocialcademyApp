//
//  Loadable.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 05.10.24.
//

import Foundation

enum Loadable<Value> {
    case loading
    case error(Error)
    case loaded(Value)
    
    var value: Value? {
        get {
            if case let .loaded(value) = self {
                return value
            }
            return nil
        }
        set {
            guard let newValue = newValue else { return }
            self = .loaded(newValue)
        }
    }
    /// This property provides a convenient way to access or modify the associated value of the loaded case, treating the enum like an optional value.
    /// It simplifies working with the enum by allowing direct access to the value when it’s in the loaded state.

}

/// Instead of referring directly to the Post model in our loaded case, we can use a generic Value type so that we can reuse this enumeration when building other parts of our app.


extension Loadable where Value: RangeReplaceableCollection {
    static var empty: Loadable<Value> { .loaded(Value()) }
}

extension Loadable: Equatable where Value: Equatable {
    static func == (lhs: Loadable<Value>, rhs: Loadable<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.error(error1), .error(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case let (.loaded(value1), .loaded(value2)):
            return value1 == value2
        default:
            return false
        }
    }
}

/// This extension provides an empty case for Value types that conform to the RangeReplaceableCollection protocol, including arrays and sets.
/// We used this protocol because it provides an initializer that creates an empty collection.

#if DEBUG
extension Loadable {
    static var error: Loadable<Value> { .error(PreviewError()) }
    
    private struct PreviewError: LocalizedError {
        let errorDescription: String? = "Lorem ipsum dolor set amet."
    }
    
    func simulate() async throws -> Value {
        switch self {
        case .loading:
            try await Task.sleep(nanoseconds: 10 * 1_000_000_000)
            fatalError("Timeout exceeded for “loading” case preview")
        case let .error(error):
            throw error
        case let .loaded(value):
            return value
        }
    }
}
#endif
