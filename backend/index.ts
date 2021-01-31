import express from 'express';

const app = express();

// health check
app.get('/api', (_, res) => res.send('Hello world'));

app.listen(8080, () => console.log('started at port 8080'));
