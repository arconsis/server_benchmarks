//
//  BookModel.swift
//
//
//  Created by Moritz Ellerbrock
//

import Foundation
import FluentKit

final class BookModel: Model {
    typealias FieldKeyStore = ModelDefinition.Book.FieldKeys

    static var schema: String = ModelDefinition.Book.schema

    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeyStore.title)
    var title: String

    @Field(key: FieldKeyStore.author)
    var author: String

    @Field(key: FieldKeyStore.publisher)
    var publisher: String

    @Field(key: FieldKeyStore.releaseDate)
    var releaseDate: Date

    init() {}

    init(id: UUID? = nil,
         title: String,
         author: String,
         publisher: String,
         releaseDate: Date) {
        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.releaseDate = releaseDate.onlyDate!
    }
}

extension Date {
    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)
        }
    }
}
