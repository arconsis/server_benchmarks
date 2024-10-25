//
//  RepositoryService.swift
//  
//
//  Created by Moritz Ellerbrock
//

import Foundation

public protocol RepositoryService {
    func createBook(title: String, author: String, publisher: String, releaseDate: Date) async throws -> RepositoryServiceModels.Book

    func getBook(with id: UUID) async throws -> RepositoryServiceModels.Book?

    func getBooks(limit: Int) async throws -> [RepositoryServiceModels.Book]

    func deleteBook(with id: UUID) async throws

    func deleteAllBooks() async throws
}
