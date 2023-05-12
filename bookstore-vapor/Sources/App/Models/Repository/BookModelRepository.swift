import Vapor
import Fluent
import Repository

enum BookModelRepositoryError: Error {
    case noBookFound
    case idInvalid
}

protocol BookModelRepository: RepositoryProtocol {
    func list() async throws -> [BookContent]

    func create(book: BookContent) async throws -> String

    func getBook(by bookId: String) async throws -> BookContent

    func delete(bookId: String) async throws -> Void

    func deleteAll() async throws -> Void
}

struct BookModelRepositoryImpl: BookModelRepository {
    var req: Request

    init(_ req: Request) {
        self.req = req
    }

    private func query() -> QueryBuilder<BookModel> {
        BookModel.query(on: req.db)
    }

    private func query(_ idString: String) throws -> QueryBuilder<BookModel> {
        guard let id = UUID(uuidString: idString) else {
            throw BookModelRepositoryError.idInvalid
        }
        return query().filter(\.$id == id)
    }

    func list() async throws -> [BookContent] {
        let builder: QueryBuilder<BookModel>
        if let limit = try? req.query.decode(PaginationContent.self).limit {
            builder =  query().limit(limit)
        } else {
            builder = query()
        }

        return try await builder.all().map { model in
            model.toContent()
        }
    }

    func create(book: BookContent) async throws -> String {
        let bookModel = book.toModel()
        try await bookModel.create(on: req.db)
        return bookModel.id?.uuidString ?? ""
    }

    func getBook(by bookId: String) async throws -> BookContent {
        guard let book = try await query(bookId).first() else {
            throw BookModelRepositoryError.noBookFound
        }
        return book.toContent()
    }

    func delete(bookId: String) async throws -> Void {
        try await query(bookId).delete()
    }

    func deleteAll() async throws -> Void {
        try await query().delete()
    }
}
