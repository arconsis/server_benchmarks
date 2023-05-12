import Vapor

public struct RepositoryId: Hashable, Codable {

    public let string: String
    
    public init(_ string: String) {
        self.string = string
    }
}
