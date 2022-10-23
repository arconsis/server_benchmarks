package com.arconsis.data.books

import com.arconsis.data.common.BOOK_ID
import java.time.Instant
import java.util.*
import javax.persistence.*

@NamedQueries(
    NamedQuery(
        name = BookEntity.LIST_BOOKS,
        query = """ select b from books b"""

    ),
    NamedQuery(
        name = BookEntity.GET_BOOK,
        query = """ select b from books b
            where b.id = :$BOOK_ID
        """
    ),
)
@Entity(name = "books")
class BookEntity(
    @Id
    @GeneratedValue
    var id: UUID? = null,
    @Column
    var title: String,
    @Column
    var author: String,
    @Column
    var publisher: String,
    @Column(name = "release_date")
    var releaseDate: Instant,
) {
    companion object {
        const val LIST_BOOKS = "list_books"
        const val GET_BOOK = "get_book"
    }
}