//
//  DatabaseFactory.swift
//  
//
//  Created by Moritz Ellerbrock
//

import Foundation
import FluentKit

public enum ServiceFactory {
    public static func makeRepositoryService(database: any Database) -> RepositoryService {
        RepositoryServiceImpl(db: database)
    }
}
