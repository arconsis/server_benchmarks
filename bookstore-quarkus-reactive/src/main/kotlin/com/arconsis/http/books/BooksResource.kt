package com.arconsis.http.books

import com.arconsis.data.books.BooksDataStore
import io.smallrye.mutiny.Uni
import jakarta.enterprise.context.ApplicationScoped
import jakarta.ws.rs.*
import jakarta.ws.rs.core.MediaType
import jakarta.ws.rs.core.Response
import java.util.*


@Path("/books")
@ApplicationScoped
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
class BooksResource(private val booksDataStore: BooksDataStore) {

    @GET
    @Path("/{bookId}")
    suspend fun getBook(@PathParam("bookId") id: UUID): Book {
        return booksDataStore.getBook(id) ?: throw NotFoundException("Book with id: $id not found")
    }

    @POST
    fun createBook(createBook: CreateBook): Uni<CreateBookResponse> {
        return booksDataStore.createBook(createBook).map { CreateBookResponse(it) }
    }

    @GET
    suspend fun getBooks(@QueryParam("limit") limit: Int?): List<Book> {
        val booksLimit = limit ?: 1000
        return booksDataStore.getBooks(booksLimit)
    }

    @DELETE
    @Path("/{bookId}")
    fun deleteBook(@PathParam("bookId") id: UUID): Uni<Response> {
        return booksDataStore.deleteBook(id).replaceWith(Response.noContent().build())
    }

    @DELETE
    fun deleteBook(): Uni<Response> {
        return booksDataStore.deleteBooks().replaceWith(Response.noContent().build())
    }
}