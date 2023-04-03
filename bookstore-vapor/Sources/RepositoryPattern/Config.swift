import Vapor
import FluentPostgresDriver
import Fluent

public func configure(_ app: Application) throws {
    try DatabaseConfiguration.setup(in: app)
}

struct DatabaseConfiguration {
    enum DatabaseConfigurationError: LocalizedError {
        case usernameMissing, passwordMissing, databaseNameMissing
    }

    let hostname: String
    let port: Int
    let username: String
    let password: String
    let database: String

    init(_ app: Application) throws {
        guard let username = Environment.get("DATABASE_USERNAME") else {
            throw DatabaseConfigurationError.usernameMissing
        }
        guard let password = Environment.get("DATABASE_PASSWORD") else {
            throw DatabaseConfigurationError.passwordMissing
        }

        let databaseName = app.environment == .testing ? "testing" : Environment.get("DATABASE_NAME")
        guard let databaseName else {
            throw DatabaseConfigurationError.databaseNameMissing
        }

        self.port = Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber
        self.hostname = Environment.get("DATABASE_HOST") ?? "db"
        self.username = username
        self.password = password
        self.database = databaseName
    }

    static func setup(in app: Application) throws {
        let dbConfig = try DatabaseConfiguration(app)
        let factoryConfig: DatabaseConfigurationFactory = .postgres(hostname: dbConfig.hostname,
                                                                    port: dbConfig.port,
                                                                    username: dbConfig.username,
                                                                    password: dbConfig.password,
                                                                    database: dbConfig.database)

        app.databases.use(factoryConfig, as: .psql)
    }
}