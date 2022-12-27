package com.arconsis.http.errors

import org.jboss.resteasy.reactive.RestResponse
import org.jboss.resteasy.reactive.server.ServerExceptionMapper
import javax.ws.rs.ClientErrorException
import javax.ws.rs.core.Response


class ExceptionMappers {

    @ServerExceptionMapper
    fun mapThrowable(throwable: Throwable): RestResponse<ErrorResponse> {

        return when (throwable) {
            is ClientErrorException -> {
                val errorResponse = ErrorResponse(
                    title = "Error",
                    detail = throwable.message ?: "Something went wrong.",
                    status = throwable.response.status

                )
                val status = Response.Status.fromStatusCode(throwable.response.status)
                RestResponse.status(status, errorResponse)
            }

            else -> {
                val status = Response.Status.INTERNAL_SERVER_ERROR
                val errorResponse = ErrorResponse(
                    title = "Error",
                    detail = "Something went wrong.",
                    status = status.statusCode

                )
                RestResponse.status(Response.Status.INTERNAL_SERVER_ERROR, errorResponse)
            }
        }
    }
}