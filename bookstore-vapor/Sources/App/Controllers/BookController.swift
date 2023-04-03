import Fluent
import Vapor

struct BookController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let books = routes.grouped("books")
        books.post(use: createBook)
        books.delete(use: deleteAllBooks)
        books.get(use: getAllBooks)

        let bookId = books.grouped(":bookId")
        bookId.get(use: getBookById)
        bookId.delete(use: deleteBookById)
    }

    func createBook(req: Request) async throws -> String {
        let dto = try req.content.decode(BookContent.self)
        return try await req.repositories.books.create(book: dto)
    }

    func deleteAllBooks(req: Request) async throws -> Response {
        try await req.repositories.books.deleteAll()
        return Response(status: .ok)
    }

    func getAllBooks(req: Request) async throws -> [BookContent] {
        return try await req.repositories.books.list()
    }

    func getBookById(req: Request) async throws -> BookContent {
        guard let bookId = req.parameters.get("bookId") else {
            throw Abort(.badRequest)
        }
        return try await req.repositories.books.getBook(by: bookId)
    }

    func deleteBookById(req: Request) async throws -> Response {
        guard let bookId = req.parameters.get("bookId") else {
            throw Abort(.badRequest)
        }
        try await req.repositories.books.delete(bookId: bookId)
        return Response(status: .ok)
    }
}
