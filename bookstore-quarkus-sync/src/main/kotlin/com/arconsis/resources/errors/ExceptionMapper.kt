package com.arconsis.resources.errors

import org.jboss.resteasy.reactive.RestResponse
import org.jboss.resteasy.reactive.RestResponse.ResponseBuilder
import org.jboss.resteasy.reactive.RestResponse.Status.fromStatusCode
import org.jboss.resteasy.reactive.server.ServerExceptionMapper
import java.util.logging.Level
import java.util.logging.Logger
import jakarta.enterprise.context.ApplicationScoped
import jakarta.ws.rs.WebApplicationException
import jakarta.ws.rs.core.HttpHeaders

@ApplicationScoped
class ExceptionMapper {
    private val logger = Logger.getLogger(ExceptionMapper::class.java.name)

    @ServerExceptionMapper
    fun mapBookNotFoundException(exception: BookNotFoundException): RestResponse<ErrorResponse> {
        return createErrorResponse("Book not found", "Book with id ${exception.bookId} not found.", 404)
    }

    @ServerExceptionMapper
    fun mapWebApplicationException(exception: WebApplicationException): RestResponse<ErrorResponse> {
        logger.log(Level.FINE, exception) { "WebApplicationException caught" }
        return createErrorResponse(exception.javaClass.name, exception.message, exception.response.status)
    }

    @ServerExceptionMapper
    fun mapWebApplicationException(throwable: Throwable): RestResponse<ErrorResponse> {
        logger.log(Level.SEVERE, throwable) { "InternalServerError caught" }
        return createErrorResponse("Internal Server Error", throwable.message, 500)
    }

    private fun createErrorResponse(title: String, message: String?, status: Int): RestResponse<ErrorResponse> {
        val errorResponse = ErrorResponse(
            title = title,
            detail = message ?: "Something went wrong.",
            status = status
        )

        return ResponseBuilder.create(fromStatusCode(status), errorResponse)
            .header(HttpHeaders.CONTENT_TYPE, PROBLEM_DETAIL_CONTENT_TYPE)
            .build()
    }
}