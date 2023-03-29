import Fluent
import Vapor

final class BookModel: Model {
    static let schema = "books"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "author")
    var author: String

    @Field(key: "release_date")
    var releaseDate: Date

    @Field(key: "publisher")
    var publisher: String

    init() { }

    init(id: UUID? = nil, title: String, author: String, releaseDate: Date, publisher: String) {
        self.id = id
        self.title = title
        self.author = author
        self.releaseDate = releaseDate
        self.publisher = publisher
    }
}

extension BookModel {
    func toContent() -> BookContent {
        BookContent(id: self.id,
                    title: self.title,
                    author: self.author,
                    releaseDate: self.releaseDate,
                    publisher: self.publisher)
    }
}
