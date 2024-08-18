// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bookstore-hummingbird",
    platforms: [
        .macOS(.v14),
    ],
    dependencies: [
        .argumentParser(),
        .hummingbird(),
        .fluent(),
        .postgresDriver(),
        .sqlDriver(),    ],
    targets: [
        .executableTarget(name: "executable",
                         dependencies: [
                            .argumentParser(),
                            .target(name: "App"),
                            .target(name: "Common"),
                         ],
                         path: "Sources/Executable"),
        .target(name: "App",
               dependencies: [
                .hummingbird(),
                .fluent(),
                .postgresDriver(),
                .sqlDriver(),
                .target(name: "Domain"),
                .target(name: "Service"),
                .target(name: "Common"),
               ],
               path: "Sources/App"),
        .target(name: "Domain",
               dependencies: [
                .hummingbird(),
                .target(name: "Service"),
               ],
               path: "Sources/Domain"),
        .target(name: "Service",
               dependencies: [
                .fluent(),
               ],
                path: "Sources/Service"),
        .target(name: "Common", path: "Sources/Common")
    ]
)

extension Package.Dependency {
    static func argumentParser() -> Package.Dependency {
        Package.Dependency.package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.1")
    }

    static func hummingbird() -> Package.Dependency {
        Package.Dependency.package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.0.0-beta.4")
    }

    static func fluent() -> Package.Dependency {
        Package.Dependency.package(url: "https://github.com/hummingbird-project/hummingbird-fluent.git", from: "2.0.0-beta.1")
    }

    static func postgresDriver() -> Package.Dependency {
        Package.Dependency.package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0")
    }

    static func sqlDriver() -> Package.Dependency {
        Package.Dependency.package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.6.0")
    }
}
extension PackageDescription.Target.Dependency {
    static func argumentParser() -> Self {
        PackageDescription.Target.Dependency.product(name: "ArgumentParser", package: "swift-argument-parser")
    }

    static func hummingbird() -> Self {
        PackageDescription.Target.Dependency.product(name: "Hummingbird", package: "hummingbird")
    }

    static func fluent() -> Self {
        PackageDescription.Target.Dependency.product(name: "HummingbirdFluent", package: "hummingbird-fluent")
    }

    static func postgresDriver() -> Self {
        PackageDescription.Target.Dependency.product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
    }

    static func sqlDriver() -> Self {
        PackageDescription.Target.Dependency.product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver")
    }
}
