//
//  Executable.swift
//  
//
//  Created by Moritz Ellerbrock
//

import ArgumentParser
import App

@main
final class Executable: AsyncParsableCommand, AppArguments {
    @Option(name: .long)
    var hostname: String = "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = 3000

    @Flag(name: .customLong("in-memory"), help: "Do you want to use an `in memory` database?")
    var inMemoryDatabase: Bool = false


    func run() async throws {
        let appBuilder = AppBuilder(arguments: self)
        let app = try await appBuilder.make()
        try await app.runService()
    }
}


