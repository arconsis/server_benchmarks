//
//  DatabaseMigrations.swift
//  
//
//  Created by Moritz Ellerbrock
//

import FluentKit
import HummingbirdFluent

public enum DatabaseMigrations {
    public static func addMigrations(to fluent: Fluent) async {
        var migrations: [any Migration] = []

        migrations.append(CreateBookModels())

        await fluent.migrations.add(migrations)
    }
}
