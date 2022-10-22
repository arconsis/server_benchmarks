CREATE TABLE Books
(
    id          UUID PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    author      VARCHAR(200) NOT NULL,
    publisher   VARCHAR(200) NOT NULL,
    release_date TIMESTAMPTZ
)