import Vapor

public protocol RepositoryProtocol {
    var req: Request { get set }
    init(_ req: Request)
}
