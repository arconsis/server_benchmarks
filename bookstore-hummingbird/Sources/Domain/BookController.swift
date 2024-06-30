//
//  BookController.swift
//  
//
//  Created by Moritz Ellerbrock
//

import Foundation
import Hummingbird
import Service

struct BookController {
    let service: RepositoryService

    init(service: RepositoryService) {
        self.service = service
    }
}

extension BookController: Controllable {
    func addRoutes(to router: Router<BasicRequestContext>) {
        router
            .group("books")
            .get(use: getBooks)
            .get(":bookId", use: getBook)
            .post(use: createBook)
            .delete(":bookId", use: deleteBook)
            .delete(use: deleteAllBooks)
    }

    @Sendable
    private func getBooks(_ request: Request, context: BasicRequestContext) async throws -> Response {
        guard
            let limitString = request.uri.queryParameters.get("limit"),
            let limit: Int = Int(limitString)
        else {
            return .init(status: .badRequest)
        }

        let books = try await service.getBooks(limit: limit)
        let codables = books.map { $0.toCodable() }
        return Response(with: codables)

    }

    @Sendable
    private func getBook(_ request: Request, context: BasicRequestContext) async throws -> Response {
        let bookId = try context.parameters.require("bookId", as: UUID.self)
        let book = try await service.getBook(with: bookId)
        let codable = book?.toCodable()
        return Response(with: codable)
    }

    @Sendable
    private func createBook(_ request: Request, context: BasicRequestContext) async throws -> Response {
        let input = try await request.decode(as: Input.self, context: context)
        let book = try await service.createBook(title: input.title,
                                                author: input.author,
                                                publisher: input.publisher,
                                                releaseDate: input.releaseDate)

        let codable = book.toCodable()
        return Response(with: codable)
    }

    @Sendable
    private func deleteBook(_ request: Request, context: BasicRequestContext) async throws -> Response {
        let bookId = try context.parameters.require("bookId", as: UUID.self)
        try await service.deleteBook(with: bookId)
        return Response(with: nil)
    }

    @Sendable
    private func deleteAllBooks(_ request: Request, context: BasicRequestContext) async throws -> Response {
        try await service.deleteAllBooks()
        return Response(with: nil)
    }
}

extension BookController {
    struct Input: Decodable {
        let title: String
        let author: String
        let publisher: String
        let releaseDate: Date
    }

    struct Output: Codable {
        let id: UUID
        let title: String
        let author: String
        let publisher: String
        let releaseDate: Date
    }
}

extension RepositoryServiceModels.Book {
    func toCodable() -> BookController.Output {
        .init(id: id,
              title: title,
              author: author,
              publisher: publisher,
              releaseDate: releaseDate)
    }
}
