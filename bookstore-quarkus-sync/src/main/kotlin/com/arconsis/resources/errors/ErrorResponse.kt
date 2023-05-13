package com.arconsis.resources.errors

const val PROBLEM_DETAIL_CONTENT_TYPE = "application/problem+json"

/**
 * Based on ProblemDetail from RFC 7807
 */
data class ErrorResponse(val title: String, val status: Int, val detail: String)