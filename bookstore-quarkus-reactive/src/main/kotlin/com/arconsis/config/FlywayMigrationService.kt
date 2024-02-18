package com.arconsis.config

import io.quarkus.runtime.StartupEvent
import org.eclipse.microprofile.config.inject.ConfigProperty
import org.flywaydb.core.Flyway
import jakarta.enterprise.context.ApplicationScoped
import jakarta.enterprise.event.Observes

@ApplicationScoped
class FlywayMigrationService(
    @ConfigProperty(name = "quarkus.datasource.reactive.url")
    private val datasourceUrl: String,
    @ConfigProperty(name = "quarkus.datasource.username")
    private val datasourceUsername: String,
    @ConfigProperty(name = "quarkus.datasource.password")
    private val datasourcePassword: String,
) {
    fun runFlywayMigration(@Observes event: StartupEvent) {
        val flyway = Flyway.configure().dataSource("jdbc:$datasourceUrl", datasourceUsername, datasourcePassword)
            .baselineVersion("0.0.1")
            .load()
        flyway.migrate()
    }
}