use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .create_table(
                Table::create()
                    .table(BookEntity::Table)
                    .if_not_exists()
                    .col(
                        ColumnDef::new(BookEntity::Id)
                            .string()
                            .not_null()
                            .primary_key(),
                    )
                    .col(ColumnDef::new(BookEntity::Title).string().not_null())
                    .col(ColumnDef::new(BookEntity::Author).string().not_null())
                    .col(ColumnDef::new(BookEntity::ReleaseDate).string().not_null())
                    .col(ColumnDef::new(BookEntity::Publisher).string().not_null())
                    .to_owned(),
            )
            .await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .drop_table(Table::drop().table(BookEntity::Table).to_owned())
            .await
    }
}

#[derive(DeriveIden)]
enum BookEntity {
    Table,
    Id,
    Title,
    Author,
    ReleaseDate,
    Publisher,
}
