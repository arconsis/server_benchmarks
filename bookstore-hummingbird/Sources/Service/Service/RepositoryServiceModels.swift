//
//  RepositoryServiceModels.swift
//  
//
//  Created by Moritz Ellerbrock
//
import Foundation

public enum RepositoryServiceModels {
    public struct Book {
        public let id: UUID
        public let title: String
        public let author: String
        public let publisher: String
        public let releaseDate: Date
    }
}
