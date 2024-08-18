//
//  File.swift
//  bookstore-hummingbird
//
//  Created by Moritz Ellerbrock on 21.07.24.
//

import Foundation
import Service

public enum DomainFactory {
    public static func makeBookController(service: RepositoryService) -> Controllable {
        BookController(service: service)
    }
}
