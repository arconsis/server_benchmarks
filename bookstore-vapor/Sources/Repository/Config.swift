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
        guard let username = Environment.get("DB_USER") else {
            throw DatabaseConfigurationError.usernameMissing
        }
        guard let password = Environment.get("DB_PASSWORD") else {
            throw DatabaseConfigurationError.passwordMissing
        }

        let databaseName = app.environment == .testing ? "testing" : Environment.get("DB_NAME")
        guard let databaseName else {
            throw DatabaseConfigurationError.databaseNameMissing
        }

        self.port = Environment.get("DB_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber
        self.hostname = Environment.get("DB_HOST") ?? "db"
        self.username = username
        self.password = password
        self.database = databaseName
    }

    var config: SQLPostgresConfiguration {
        let tls: PostgresConnection.Configuration.TLS = .disable
        return .init(hostname: hostname,
              port: port,
              username: username,
              password: password,
              database: database,
              tls: tls)
    }

    static func setup(in app: Application) throws {
        let dbConfig = try DatabaseConfiguration(app)
        let factoryConfig: DatabaseConfigurationFactory = .postgres(configuration: dbConfig.config)
        app.databases.use(factoryConfig, as: .psql)
    }
}
