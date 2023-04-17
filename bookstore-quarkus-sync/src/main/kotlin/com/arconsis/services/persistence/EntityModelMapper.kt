package com.arconsis.services.persistence

import com.arconsis.services.models.Book
import com.arconsis.services.persistence.entities.BookEntity

fun List<BookEntity>.toBooks(): List<Book> = map { it.toBook() }
fun BookEntity.toBook() = Book(
    id = requireNotNull(id),
    title = title,
    author = author,
    publisher = publisher,
    releaseDate = releaseDate
)