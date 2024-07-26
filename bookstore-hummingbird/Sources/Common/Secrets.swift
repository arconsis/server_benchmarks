//
//  Secrets.swift
//  
//
//  Created by Moritz Ellerbrock
//

import Foundation

public enum SecretsError: Error {
    case secretNotSet(key: String)
}

@dynamicMemberLookup
public struct Secrets: Encodable {
    public let dbHostname = "POSTGRES_HOST"
    public let dbUsername = "POSTGRES_USER"
    public let dbPassword = "POSTGRES_PASSWORD"
    public let dbPort = "POSTGRES_PORT"
    public let dbName = "POSTGRES_DB"
    public let dbUrl = "POSTGRES_URL"


    public static subscript<T>(dynamicMember keyPath: KeyPath<Secrets, T>) -> T {
        let obj = Secrets()
        let key = obj[keyPath: keyPath] as! String
        let secret = obj.storedValue(for: key)!
        return secret as! T
    }

    func storedValue(for key: String) -> String? {
        if key == dbHostname {
            return Environment.get(key) ?? "localhost"
        } else if key == dbUsername {
            return Environment.get(key) 
        } else if key == dbPassword {
            return Environment.get(key) 
        } else if key == dbPort {
            return Environment.get(key) ?? "5432"
        } else if key == dbName {
            return Environment.get(key)
        } else if key == dbUrl {
            return Environment.get(key) ?? "postgres://postgres:secret@postgres/books-db"
        } else{
            return nil
        }
    }

    public static func verifySetup() throws {
        let obj = Secrets()
        let dict = obj.toDict()
        for key in dict.values {
            guard let _ = obj.storedValue(for: key) else {
                throw SecretsError.secretNotSet(key: key)
            }
        }
    }
}
