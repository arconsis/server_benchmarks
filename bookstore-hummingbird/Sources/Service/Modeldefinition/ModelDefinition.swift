//
//  ModelDefinition.swift
//  
//
//  Created by Moritz Ellerbrock
//

import FluentKit
import HummingbirdFluent

enum ModelDefinition {
    enum Book {
        static var schema: String { "books" }
        enum FieldKeys {
            static var title: FieldKey { "title" }
            static var author: FieldKey { "author" }
            static var publisher: FieldKey { "publisher" }
            static var releaseDate: FieldKey { "release_date" }
        }
    }
}
