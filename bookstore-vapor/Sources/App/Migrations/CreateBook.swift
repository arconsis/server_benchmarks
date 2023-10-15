import Fluent

struct CreateBooks: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(BookModel.schema)
            .id()
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("release_date", .date, .required)
            .field("publisher", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("books").delete()
    }
}
