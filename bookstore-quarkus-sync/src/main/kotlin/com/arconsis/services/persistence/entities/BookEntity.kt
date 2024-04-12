package com.arconsis.services.persistence.entities

import com.arconsis.services.persistence.entities.BookEntity.Companion.DELETE_ALL_BOOKS
import com.arconsis.services.persistence.entities.BookEntity.Companion.DELETE_BY_ID
import com.arconsis.services.persistence.entities.BookEntity.Companion.FIND_ALL
import java.time.LocalDate
import java.util.*
import jakarta.persistence.*

@NamedQueries(
    NamedQuery(
        name = FIND_ALL,
        query = "SELECT b FROM BookEntity b"
    ),
    NamedQuery(
        name = DELETE_BY_ID,
        query = "DELETE FROM BookEntity b WHERE id = :id"
    ),
    NamedQuery(
        name = DELETE_ALL_BOOKS,
        query = "DELETE FROM BookEntity b"
    )
)
@Entity
@Table(name = "books")
class BookEntity(
    @Id
    @GeneratedValue
    val id: UUID? = null,
    @Column(nullable = false)
    val title: String,
    @Column(nullable = false)
    val author: String,
    @Column(nullable = false)
    val publisher: String,
    @Column(name = "release_date")
    val releaseDate: LocalDate,
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as BookEntity

        if (id != other.id) return false

        return true
    }

    override fun hashCode(): Int {
        return id?.hashCode() ?: 0
    }

    override fun toString(): String {
        return "BookEntity(id=$id, title='$title', author='$author', publisher='$publisher', releaseDate=$releaseDate)"
    }

    companion object {
        const val FIND_ALL = "BOOKS_FIND_ALL"
        const val DELETE_BY_ID = "BOOKS_DELETE_BY_ID"
        const val DELETE_ALL_BOOKS = "BOOKS_DELETE_ALL_BOOKS"
    }
}
