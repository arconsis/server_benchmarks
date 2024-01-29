pluginManagement {
    val quarkusPluginVersion: String by settings
    val quarkusPluginId: String by settings

    val kotlinVersion: String by settings

    repositories {
        mavenCentral()
        gradlePluginPortal()
        mavenLocal()
    }
    plugins {
        kotlin("jvm") version kotlinVersion
        kotlin("plugin.allopen") version kotlinVersion
        kotlin("plugin.jpa") version kotlinVersion
        kotlin("plugin.serialization") version kotlinVersion
        id(quarkusPluginId) version quarkusPluginVersion
    }
}
rootProject.name="bookstore-quarkus-mutiny"