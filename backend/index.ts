import express from 'express';

const app = express();

// health check
app.get('/api', (_, res) => res.send('Hello world'));

app.get('/api/test', (_, res) => res.send('Hello world2'));

app.listen(8080, () => console.log('started at port 8080'));
