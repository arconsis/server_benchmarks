import Vapor

public struct RepositoryFactory {
    private var registry: RepositoryRegistry
    private var req: Request
    
    init(_ req: Request, _ registry: RepositoryRegistry) {
        self.req = req
        self.registry = registry
    }

    public func make(_ id: RepositoryId) -> Repository {
        registry.make(id, req)
    }
}
