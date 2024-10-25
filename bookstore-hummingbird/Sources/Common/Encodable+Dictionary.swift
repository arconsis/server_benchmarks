//
//  Encodable+Dictionary.swift
//
//
//  Created by Moritz Ellerbrock
//

import Foundation

public extension Encodable {
    func toDict() -> [String: String] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = jsonObject as? [String: Any] else {
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
