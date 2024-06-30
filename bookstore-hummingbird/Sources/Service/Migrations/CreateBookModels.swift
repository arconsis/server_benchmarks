//
//  CreateBookModels.swift
//  
//
//  Created by Moritz Ellerbrock
//

import FluentKit

struct CreateBookModels: AsyncMigration {
    typealias BookFieldKeys = ModelDefinition.Book.FieldKeys

    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema(ModelDefinition.Book.schema)
            .id()
            .field(BookFieldKeys.title, .string, .required)
            .field(BookFieldKeys.author, .string, .required)
            .field(BookFieldKeys.publisher, .string, .required)
            .field(BookFieldKeys.releaseDate, .date, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(ModelDefinition.Book.schema)
            .delete()
    }
}
