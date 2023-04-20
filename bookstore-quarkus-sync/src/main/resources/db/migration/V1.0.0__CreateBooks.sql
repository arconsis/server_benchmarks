CREATE TABLE Books
(
    id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    author       VARCHAR(200) NOT NULL,
    publisher    VARCHAR(200) NOT NULL,
    release_date DATE
)