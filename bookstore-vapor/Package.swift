// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "bookstore",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.92.6"),
        .package(url: "https://github.com/vapor/fluent.git", exact: "4.9.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", exact: "2.8.0"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "Vapor", package: "vapor"),
                .target(name: "Repository"),
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .target(
            name: "Repository",
            dependencies: [
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
        // Testing targets
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
    ]
)
