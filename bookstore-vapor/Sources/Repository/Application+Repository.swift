import Vapor

public extension Application {

    private struct Key: StorageKey {
        typealias Value = RepositoryRegistry
    }
    
    var repositories: RepositoryRegistry {
        if storage[Key.self] == nil {
            storage[Key.self] = .init(self)
        }
        return storage[Key.self]!
    }
}
