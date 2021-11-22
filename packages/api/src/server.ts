import express from 'express';
import { Recipe } from '@cookbook/shared';

const api = express();
const port = 8080;

const recipe: Recipe = {
  id: "id",
  owner: "jmaxwell",
  title: "one",
  ingredients: [],
  directions: [],
  categories: [],
};
console.log(recipe);

api.get('/', (req, res) => res.json({
  message: 'Hello World!'
}));

api.listen(port, () => console.log(`Server started at http://localhost:${port}`));
