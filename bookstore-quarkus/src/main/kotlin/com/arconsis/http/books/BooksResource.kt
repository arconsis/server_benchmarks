package com.arconsis.http.books

import com.arconsis.data.BooksRepository
import java.util.UUID
import javax.enterprise.context.ApplicationScoped
import javax.ws.rs.Consumes
import javax.ws.rs.DELETE
import javax.ws.rs.GET
import javax.ws.rs.POST
import javax.ws.rs.Path
import javax.ws.rs.PathParam
import javax.ws.rs.Produces
import javax.ws.rs.core.MediaType


@Path("/books")
@ApplicationScoped
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
class BooksResource(private val booksRepository: BooksRepository) {

    @GET
    @Path("/{bookId}")
    suspend fun getBook(@PathParam("bookId") id: UUID): Book {
        return booksRepository.getBook(id)
    }

    @POST
    suspend fun createBook(createBook: CreateBook): CreateBookResponse {
        val bookId = booksRepository.createBook(createBook)
        return CreateBookResponse(bookId)

    }

    @GET
    suspend fun getBooks(): List<Book> {
        return booksRepository.getBooks()
    }

    @DELETE
    @Path("/{bookId}")
    suspend fun deleteBook(@PathParam("bookId") id: UUID) {
        return booksRepository.deleteBook(id)
    }
}