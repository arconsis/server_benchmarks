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
    public let dbHostname = "DATABASE_HOST"
    public let dbUsername = "DATABASE_USERNAME"
    public let dbPassword = "DATABASE_PASSWORD"
    public let dbPort = "DATABASE_POST"
    public let dbName = "DATABASE_NAME"


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
            return Environment.get(key) ?? "postgres"
        } else if key == dbPassword {
            return Environment.get(key) ?? "postgres"
        } else if key == dbPort {
            return Environment.get(key) ?? "5432"
        } else if key == dbName {
            return Environment.get(key) ?? "postgres"
        } else {
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
