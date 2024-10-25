//
//  RepositoryServiceImpl.swift
//
//
//  Created by Moritz Ellerbrock
//

import Foundation
import FluentKit

class RepositoryServiceImpl {
    private let db: any Database

    init(db: any Database) {
        self.db = db
    }

    private func query() -> QueryBuilder<BookModel> {
        BookModel.query(on: self.db)
    }

    private func query(_ id: UUID) -> QueryBuilder<BookModel> {
        query().filter(\.$id == id)
    }
}

extension RepositoryServiceImpl: RepositoryService {
    func createBook(title: String, author: String, publisher: String, releaseDate: Date) async throws -> RepositoryServiceModels.Book {
        let model = BookModel(title: title, author: author, publisher: publisher, releaseDate: releaseDate)

        try await model.save(on: self.db)

        return try model.toDto()
    }

    func getBook(with id: UUID) async throws -> RepositoryServiceModels.Book? {
        let model = try await query(id).first()
        return try model?.toDto()
    }

    func getBooks(limit: Int) async throws -> [RepositoryServiceModels.Book] {
        let models = try await query().limit(limit).all()
        return try models.map { try $0.toDto() }
    }

    func deleteBook(with id: UUID) async throws {
        let model = try await query(id).first()
        try await model?.delete(on: self.db)
    }

    func deleteAllBooks() async throws {
        let models = try await query().all()
        try await models.delete(on: self.db)
    }
}


private extension BookModel {
    func toDto() throws -> RepositoryServiceModels.Book {
        let id = try self.requireID()
        return .init(id: id,
                     title: title,
                     author: author,
                     publisher: publisher,
                     releaseDate: releaseDate)
    }
}
