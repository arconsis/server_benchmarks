import Vapor

struct PaginationContent: Content {
    let limit: Int
}
