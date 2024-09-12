import Vapor

struct BookContent: Content {
    let id: UUID?
    let title: String
    let author: String
    let releaseDate: Date
    let publisher: String
}

extension BookContent {
    func toModel() -> BookModel {
        BookModel(id: self.id,
                  title: self.title,
                  author: self.author,
                  releaseDate: self.releaseDate,
                  publisher: self.publisher)
    }
}
