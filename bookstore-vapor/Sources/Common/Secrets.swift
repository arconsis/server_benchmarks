//
//  File.swift
//
//
//  Created by Moritz Ellerbrock on 30.06.24.
//

import Foundation

public enum MandatorySecretError: Error {
    case setupMissing(String)
    case decryptionFailed(String)
}

public enum FeauterSecretError: Error {
    case setupMissing(String)
    case decryptionFailed(String)
}

@dynamicMemberLookup
public struct Secrets: Encodable {
    // mandatory
    public let dbUsername = "DATABASE_USERNAME"
    public let dbPassword = "DATABASE_PASSWORD"
    public let dbName = "DATABASE_NAME" // newsletter
    public let dbPort = "DATABASE_PORT" // 5432
    public let dbHost = "DATABASE_HOST" // db

    // Encodable
    private enum CodingKeys: String, CodingKey {
        case dbUsername, dbPassword, dbName, dbPort, dbHost
    }

    private static let mandatory: [String] = {
        [
            "DATABASE_USERNAME",
            "DATABASE_PASSWORD",
            "DATABASE_NAME",
            "DATABASE_PORT",
            "DATABASE_HOST",
        ]
    }()

    private func isMandatory(_ key: String) -> Bool {
        Self.mandatory.contains(key)
    }

    private func storedValue(_ value: String) -> String? {
        if value == dbHost {
            return Environment.get(value) ?? "localhost"
        } else if value == dbName {
            return Environment.get(value) ?? "postgres"
        } else if value == dbUsername {
            return Environment.get(value) ?? "postgres"
        } else if value == dbPassword {
            return Environment.get(value) ?? "My unsafe Secret"
        } else if value == dbPort {
            return Environment.get(value) ?? "5432"
        } else {
            return Environment.get(value)
        }
    }

    public static subscript<T>(dynamicMember keyPath: KeyPath<Secrets, T>) -> T {
        let obj = Secrets()
        let key = obj[keyPath: keyPath] as! String
        let secret = obj.storedValue(key)!
        return secret as! T
    }

    public static func verifyValue(for keyPath: KeyPath<Secrets, some Any>) -> Bool {
        let obj = Secrets()
        let key = obj[keyPath: keyPath] as! String
        return obj.storedValue(key) != nil
    }

    public static func verifySetup() throws {
        let object = Secrets()
        let dict = object.toDict()
        for key in dict.values {
            if object.isMandatory(key) {
                guard let _ = object.storedValue(key) else {
                    let error = MandatorySecretError.setupMissing(key)
                    throw error
                }
            } else {
                do {
                    guard let _ = object.storedValue(key) else {
                        throw FeauterSecretError.setupMissing(key)
                    }
                } catch {
                    print(String(reflecting: error))
                }
            }
        }
    }
}


enum Environment {
    case testing, develop, staging, production

    static func getEnvironment() -> Environment {
        environment(from: Self.get("environment"))
    }

    private static func environment(from text: String?, fallback: Environment = .develop) -> Environment {
        guard let environment = text?.lowercased() else { return fallback }
        if environment.hasPrefix("dev") {
            return .develop
        } else if environment.hasPrefix("stag") {
            return .staging
        } else if environment.hasPrefix("prod") {
            return .production
        } else if environment.hasPrefix("test") {
            return .production
        } else {
            return .develop
        }
    }
}

extension Environment {
    static func get(_ key: String) -> String? {
        let env = ProcessInfo.processInfo.environment
        return env[key]
    }
}

extension Encodable {
    func toDict() -> [String: String] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = jsonObject as? [String: Any]
        else {
            return [:]
        }

        var stringDict: [String: String] = [:]
        for (key, value) in dictionary {
            if let stringValue = value as? String {
                stringDict[key] = stringValue
            } else {
                stringDict[key] = "\(value)"
            }
        }
        return stringDict
    }
}
