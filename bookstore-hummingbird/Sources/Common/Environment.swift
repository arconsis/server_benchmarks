//
//  Environment.swift
//  
//
//  Created by Moritz Ellerbrock
//
import Foundation

enum Environment {
    static func get(_ key: String) -> String? {
        let env = ProcessInfo.processInfo.environment
        return env[key]
    }
}
