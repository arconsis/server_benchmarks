package com.arconsis.http.errors

import org.jboss.logging.Logger
import org.jboss.resteasy.reactive.RestResponse
import org.jboss.resteasy.reactive.server.ServerExceptionMapper
import jakarta.ws.rs.ClientErrorException
import jakarta.ws.rs.core.HttpHeaders
import jakarta.ws.rs.core.Response


class ExceptionMappers(val logger: Logger) {

    @ServerExceptionMapper
    fun mapThrowable(throwable: Throwable): RestResponse<ErrorResponse> {
        logger.error(throwable)
        return when (throwable) {
            is ClientErrorException -> {
                val errorResponse = ErrorResponse(
                    title = "Error",
                    detail = throwable.message ?: "Something went wrong.",
                    status = throwable.response.status

                )
                val status = Response.Status.fromStatusCode(throwable.response.status)
                RestResponse.ResponseBuilder.create(status, errorResponse)
                    .header(HttpHeaders.CONTENT_TYPE, PROBLEM_DETAIL_CONTENT_TYPE).build()
            }

            else -> {
                val status = Response.Status.INTERNAL_SERVER_ERROR
                val errorResponse = ErrorResponse(
                    title = "Error",
                    detail = "Something went wrong.",
                    status = status.statusCode

                )
                RestResponse.ResponseBuilder.create(status, errorResponse)
                    .header(HttpHeaders.CONTENT_TYPE, PROBLEM_DETAIL_CONTENT_TYPE).build()
            }
        }
    }
}