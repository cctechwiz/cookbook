export interface Recipe {
  id: string;
  owner: string;
  title: string;
  ingredients: IngredientsGroup[];
  directions: DirectionsGroup[];
  categories: string[];
}

export interface IngredientsGroup {
  header: string;
  ingredients: string[];
}

export interface DirectionsGroup {
  header: string;
  directions: string[];
}
