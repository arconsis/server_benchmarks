package com.arconsis.http.books.dto

import java.time.Instant

data class BookCreate(
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: Instant,
    val tags: MutableSet<String>,
)
