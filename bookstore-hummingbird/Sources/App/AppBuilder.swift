//
//  AppBuilder.swift
//  
//
//  Created by Moritz Ellerbrock
//

import Foundation
import Hummingbird
import HummingbirdFluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Service
import Common
import Domain

public final class AppBuilder {
    private let arguments: AppArguments

    public init(arguments: AppArguments) {
        self.arguments = arguments
    }

    public func make() async throws -> any ApplicationProtocol {
        try Secrets.verifySetup()
        let fluent: Fluent = makeFluent()
        await DatabaseMigrations.addMigrations(to: fluent)

        let router = Router()

        let service = ServiceFactory.makeRepositoryService(database: fluent.db())


        let config =  ApplicationConfiguration(address: .hostname(arguments.hostname, port: arguments.port))
        var app = Application(router: router, configuration: config)

        app.addServices(fluent)

        app.runBeforeServerStart {
            try await fluent.migrate()
        }

        return app
    }

    private func makeFluent() -> Fluent {
        let logger = Logger(label: "Fluent")
        let fluent = Fluent(logger: logger)

        if arguments.inMemoryDatabase {
            fluent.databases.use(.sqlite(.memory), as: .sqlite)
        } else {
            let config = createPostgresConfiguration()
            fluent.databases.use(.postgres(configuration: config), as: .psql)
        }

        return fluent
    }

    private func createPostgresConfiguration() -> SQLPostgresConfiguration {
        .init(hostname: Secrets.dbHostname,
              port: Int(Secrets.dbPort) ?? 5432,
              username: Secrets.dbUsername,
              password: Secrets.dbPassword,
              database: Secrets.dbName,
              tls: .disable)
    }
}
