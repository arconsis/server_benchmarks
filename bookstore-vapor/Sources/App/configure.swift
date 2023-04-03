import Fluent
import Vapor
import RepositoryPattern

// configures your application
public func configure(_ app: Application) async throws {
    // register repository
    try RepositoryPattern.configure(app)
    // add migrations
    app.migrations.add(CreateBooks())

    try await app.autoMigrate()

    try await RepositoryRegistration.bootstrap(for: app)

    setupCustomDateCoder()

    // register routes
    try routes(app)
}

func setupCustomDateCoder() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    ContentConfiguration.global.use(encoder: encoder, for: .json)


    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    ContentConfiguration.global.use(decoder: decoder, for: .json)
}