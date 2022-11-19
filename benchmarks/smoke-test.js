import http from 'k6/http';
import {check, sleep} from 'k6';

export const options = {
    vus: 1, // 1 user looping for 1 minute
    duration: '1m',

    thresholds: {
        http_req_duration: ['p(99)<1500'], // 99% of requests must complete below 1.5s
    },
};

const BASE_URL = 'http://localhost:3000';

export default () => {

    const params = {
        headers: {
            'Content-Type': 'application/json',
        },
    };

    const payload = JSON.stringify({
        title: 'Hobbit',
        author: 'J. R. R. Tolkien',
        releaseDate: '1937-09-21',
        publisher: 'George Allen & Unwin'
    })

    const createBookRes = http.post(`${BASE_URL}/books`, payload, params);

    check(createBookRes, {
        'Book created successfully': (resp) => resp.json('id') !== '',
    });

    const bookId = createBookRes.json('id')

    const book = http.get(`${BASE_URL}/books/${bookId}`).json();
    check(book, {'retrieved book': (book) => book.id === bookId});

    http.del(`${BASE_URL}/books/${bookId}`);

    sleep(1);
};
