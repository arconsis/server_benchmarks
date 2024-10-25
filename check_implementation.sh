#!/usr/bin/perl

use strict;
use warnings;
use JSON qw(decode_json);
use LWP::UserAgent;
use HTTP::Request;

# Check if the port argument is provided
my $port = shift || 3000;

print "Using port $port\n";
my $base_url = "http://localhost:$port";
my $limit = 10;  # Adjust the limit as needed

# Function to call an endpoint and collect data
sub call_endpoint {
    my ($method, $endpoint, $data) = @_;
    my $url = "$base_url$endpoint";
    my $ua = LWP::UserAgent->new;

    my $req;
    if ($method eq 'GET') {
        $req = HTTP::Request->new(GET => $url);
    } elsif ($method eq 'POST') {
        $req = HTTP::Request->new(POST => $url);
        $req->header('Content-Type' => 'application/json');
        $req->content($data);
    } elsif ($method eq 'DELETE') {
        $req = HTTP::Request->new(DELETE => $url);
    }

    my $response = $ua->request($req);
    return $response->decoded_content;
}

# Function to remove the 'id' field from JSON object
sub remove_id {
    my $json_str = shift;
    my $json_data = decode_json($json_str);
    delete $json_data->{id};
    return $json_data;
}

# Function to compare two JSON objects by key-value pairs
sub compare_json_objects {
    my ($fetched, $expected) = @_;

    foreach my $key (keys %$expected) {
        if (!exists $fetched->{$key} || $fetched->{$key} ne $expected->{$key}) {
            return 0;
        }
    }

    return 1;
}

# Initial book data to populate the DB
my @books = (
    '{"title":"The Silent Horizon","author":"Alex Mercer","publisher":"Mercer Publishing","releaseDate":"2020-01-15"}',
    '{"title":"Whispers of the Past","author":"Bethany Cole","publisher":"Cole Books","releaseDate":"2019-05-23"}',
    '{"title":"Echoes in the Valley","author":"Carlos Reyes","publisher":"Reyes House","releaseDate":"2018-11-30"}',
    '{"title":"The Last Light","author":"Diana Winters","publisher":"Winter Reads","releaseDate":"2021-07-20"}',
    '{"title":"Mystery of the Lake","author":"Ethan Brown","publisher":"Brown & Co.","releaseDate":"2017-09-14"}',
    '{"title":"Journey to the Unknown","author":"Fiona Hart","publisher":"Hart Publishing","releaseDate":"2022-03-19"}',
    '{"title":"Secrets of the Forest","author":"Gavin Knight","publisher":"Knight Books","releaseDate":"2021-12-11"}',
    '{"title":"Shadows of the Mind","author":"Hannah White","publisher":"White Pages","releaseDate":"2020-10-25"}',
    '{"title":"Beyond the Stars","author":"Isaac Green","publisher":"Greenlight Books","releaseDate":"2016-08-05"}',
    '{"title":"Dreams of Tomorrow","author":"Julia Black","publisher":"Black Ink","releaseDate":"2019-04-09"}'
);

# Array to store book UUIDs
my @book_ids;

# Create initial books
print "Creating initial books...\n";
foreach my $book (@books) {
    my $response = call_endpoint('POST', '/books', $book);
    my $book_data = decode_json($response);
    push @book_ids, $book_data->{id};
}

# Fetch the list of books and store the response
my $book_list = call_endpoint('GET', "/books?limit=$limit");
print "Fetched book list:\n$book_list\n";
print "----------------------------\n";

# Function to verify if fetched book matches expected book data
sub verify_book {
    my ($book_id, $expected_book) = @_;
    my $fetched_book = call_endpoint('GET', "/books/$book_id");
    my $fetched_data = remove_id($fetched_book);
    my $expected_data = decode_json($expected_book);

    if (compare_json_objects($fetched_data, $expected_data)) {
        print "Book $book_id verification PASSED\n";
    } else {
        print "Book $book_id verification FAILED\n";
        print "Expected: ", encode_json($expected_data), "\n";
        print "Fetched: ", encode_json($fetched_data), "\n";
    }
    print "----------------------------\n";
}

# Verify each created book by its UUID
for (my $i = 0; $i < scalar @book_ids; $i++) {
    verify_book($book_ids[$i], $books[$i]);
}

# Test if the limit parameter is applied correctly
my $test_limit = 5;
my $limited_books = call_endpoint('GET', "/books?limit=$test_limit");
my $limited_books_data = decode_json($limited_books);
my $limited_books_count = scalar @$limited_books_data;

if ($limited_books_count == $test_limit) {
    print "Limit parameter test PASSED: Fetched $limited_books_count books with limit $test_limit.\n";
} else {
    print "Limit parameter test FAILED: Expected $test_limit books, but got $limited_books_count.\n";
}

print "----------------------------\n";

# Delete all books using their UUIDs
print "Deleting all books...\n";
foreach my $book_id (@book_ids) {
    call_endpoint('DELETE', "/books/$book_id");
}

# Fetch the list of books again to verify all books are deleted
my $final_book_list = call_endpoint('GET', "/books?limit=$limit");
print "Final book list after deletion:\n$final_book_list\n";
print "----------------------------\n";
