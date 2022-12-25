package com.arconsis.http.books

import com.arconsis.common.UUIDSerializer
import kotlinx.datetime.LocalDate
import kotlinx.serialization.Serializable
import java.util.*

@Serializable
data class Book(
    @Serializable(with = UUIDSerializer::class)
    val id: UUID,
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: LocalDate
)
