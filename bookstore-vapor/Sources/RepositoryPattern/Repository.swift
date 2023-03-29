import Vapor

public protocol Repository {
    var req: Request { get set }
    init(_ req: Request)
}
