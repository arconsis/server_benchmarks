use sea_orm_migration::prelude::*;
use sea_orm_migration::sea_orm::ConnectionTrait;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        let db = manager.get_connection();

        // Use `execute_unprepared` if the SQL statement doesn't have value bindings
        db.execute_unprepared(
            "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";
                CREATE TABLE IF NOT EXISTS books (
                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                title VARCHAR(200) NOT NULL,
                author VARCHAR(200) NOT NULL,
                publisher VARCHAR(200) NOT NULL,
                release_date DATE NOT NULL
            );"
        ).await?;

        Ok(())
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .get_connection()
            .execute_unprepared("DROP TABLE books")
            .await?;

        Ok(())
    }
}
