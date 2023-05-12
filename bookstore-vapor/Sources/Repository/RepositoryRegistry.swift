import Vapor

public final class RepositoryRegistry {

    private let app: Application
    private var builders: [RepositoryId: ((Request) -> RepositoryProtocol)]

    init(_ app: Application) {
        self.app = app
        self.builders = [:]
    }

    func builder(_ req: Request) -> RepositoryFactory {
        .init(req, self)
    }
    
    func make(_ id: RepositoryId, _ req: Request) -> RepositoryProtocol {
        guard let builder = builders[id] else {
            fatalError("Repository for id `\(id.string)` is not configured.")
        }
        return builder(req)
    }
    
    public func register(_ id: RepositoryId, _ builder: @escaping (Request) -> RepositoryProtocol) {
        builders[id] = builder
    }
}
