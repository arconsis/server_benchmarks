package com.arconsis.http.books.dto

import java.time.Instant

data class CreateBook(
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: Instant,
)
