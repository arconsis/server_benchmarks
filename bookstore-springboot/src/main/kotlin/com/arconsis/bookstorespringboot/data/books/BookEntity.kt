package com.arconsis.bookstorespringboot.data.books

import com.arconsis.bookstorespringboot.http.books.Book
import com.arconsis.bookstorespringboot.http.books.CreateBook
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import java.time.Instant
import java.util.UUID

@Table("books")
data class BookEntity(
    @Id
    val id: UUID? = null,
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: Instant,
)

fun BookEntity.toBook() = Book(
    id = id!!,
    title = title,
    author = author,
    publisher = publisher,
    releaseDate = releaseDate
)

fun CreateBook.toBookEntity() = BookEntity(
    title = title,
    author = author,
    publisher = publisher,
    releaseDate = releaseDate
)