package com.arconsis.resources.books

import com.arconsis.resources.books.dtos.BookDto
import com.arconsis.resources.books.dtos.BookIdDto
import com.arconsis.services.models.Book

fun Book.toBookId(): BookIdDto = BookIdDto(id)

fun Book.toDto(): BookDto = BookDto(id, title, author, publisher, releaseDate)

fun List<Book>.toDtos(): List<BookDto> = map { it.toDto() }