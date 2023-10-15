import Vapor
import Repository

extension RepositoryId {
    static let book = RepositoryId("book")
}

enum RepositoryRegistration {
    static func bootstrap(for app: Application) async throws {
        app.repositories.register(.book) { req in
            BookModelRepositoryImpl(req)
        }
    }
}

extension RepositoryFactory {
    var books: BookModelRepository {
        guard let result = make(.book) as? BookModelRepository else {
            fatalError("Book repository is not configured")
        }
        return result
    }
}
