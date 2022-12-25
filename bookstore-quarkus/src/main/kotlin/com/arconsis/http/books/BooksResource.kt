package com.arconsis.http.books

import com.arconsis.data.books.BooksDataStore
import io.quarkus.hibernate.reactive.panache.common.runtime.ReactiveTransactional
import io.smallrye.mutiny.Uni
import java.util.*
import javax.enterprise.context.ApplicationScoped
import javax.ws.rs.Consumes
import javax.ws.rs.DELETE
import javax.ws.rs.GET
import javax.ws.rs.NotFoundException
import javax.ws.rs.POST
import javax.ws.rs.Path
import javax.ws.rs.PathParam
import javax.ws.rs.Produces
import javax.ws.rs.QueryParam
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response


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

    @ReactiveTransactional
    @POST
    fun createBook(createBook: CreateBook): Uni<CreateBookResponse> {
        return booksDataStore.createBook(createBook).map { CreateBookResponse(it) }
    }

    @GET
    suspend fun getBooks(@QueryParam("limit") limit: Int = 1000): List<Book> {
        return booksDataStore.getBooks(limit)
    }

    @ReactiveTransactional
    @DELETE
    @Path("/{bookId}")
    fun deleteBook(@PathParam("bookId") id: UUID): Uni<Response> {
        return booksDataStore.deleteBook(id).replaceWith(Response.noContent().build())
    }

    @ReactiveTransactional
    @DELETE
    fun deleteBook(): Uni<Response> {
        return booksDataStore.deleteBooks().replaceWith(Response.noContent().build())
    }
}