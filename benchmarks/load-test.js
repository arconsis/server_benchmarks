import http from 'k6/http';
import {check, sleep} from 'k6';

export const options = {
    stages: [
        {duration: '5m', target: 100}, // simulate ramp-up of traffic from 1 to 100 users over 5 minutes.
        {duration: '10m', target: 100}, // stay at 100 users for 10 minutes
        {duration: '5m', target: 0}, // ramp-down to 0 users
    ],
    thresholds: {
        'http_req_duration': ['p(99)<1500'], // 99% of requests must complete below 1.5s
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
        'book created successfully': (resp) => resp.json('id') !== '',
    });

    const bookId = createBookRes.json('id')

    const book = http.get(`${BASE_URL}/books/${bookId}`).json();
    check(book, {'retrieved book': (book) => book.id === bookId});

    http.del(`${BASE_URL}/books/${bookId}`);

    sleep(1);
};
