package com.arconsis.data.books

import com.arconsis.http.books.dto.Book

fun BookEntity.toBook(): Book {
    return Book(
        id = this.id!!,
        title = this.title,
        author = this.author,
        publisher = this.publisher,
        releaseDate = this.releaseDate,
    )
}

fun List<BookEntity>.toBooks(): List<Book> {
    return this.map { it.toBook() }
}
