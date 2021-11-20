import express from 'express';

const api = express();
const port = 8080;

api.get('/', (req, res) => res.json({
  message: 'Hello World!'
}));

api.listen(port, () => console.log(`Server started at http://localhost:${port}`));
