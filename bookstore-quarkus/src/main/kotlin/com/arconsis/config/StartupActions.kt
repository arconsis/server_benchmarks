package com.arconsis.config

import io.quarkus.runtime.StartupEvent
import javax.enterprise.event.Observes

class StartupActions(
    private val migrationService: MigrationService,
) {
    fun onStartup(@Observes event: StartupEvent) {
        migrationService.runMigration()
    }
}