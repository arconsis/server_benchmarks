package com.arconsis.config

import org.eclipse.microprofile.config.inject.ConfigProperty
import org.flywaydb.core.Flyway
import javax.enterprise.context.ApplicationScoped

@ApplicationScoped
class FlywayMigrationService(
    @ConfigProperty(name = "quarkus.datasource.reactive.url")
    private val datasourceUrl: String,
    @ConfigProperty(name = "quarkus.datasource.username")
    private val datasourceUsername: String,
    @ConfigProperty(name = "quarkus.datasource.password")
    private val datasourcePassword: String,
) : MigrationService {
    override fun runMigration() {
        val flyway: Flyway = Flyway.configure()
            .dataSource("jdbc:$datasourceUrl", datasourceUsername, datasourcePassword)
            .baselineVersion("0.0.1")
            .load()
        val migrateResult = flyway.migrate()
        if (migrateResult.migrationsExecuted > 0) {
        }
    }
}