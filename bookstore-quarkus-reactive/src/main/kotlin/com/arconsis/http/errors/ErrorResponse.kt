package com.arconsis.http.errors

import kotlinx.serialization.Serializable

const val PROBLEM_DETAIL_CONTENT_TYPE = "application/problem+json"

/**
 * Based on ProblemDetail from RFC 7807
 */
@Serializable
data class ErrorResponse(val title: String, val status: Int, val detail: String)