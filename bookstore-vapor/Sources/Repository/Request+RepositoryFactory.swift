import Vapor

public extension Request {
    var repositories: RepositoryFactory {
        application.repositories.builder(self)
    }
}
