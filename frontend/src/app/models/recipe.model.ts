export type Categoria = 'DOCE' | 'SALGADO' | 'BEBIDA' | 'SOBREMESA';

export interface Recipe {
  id: number;
  nome: string;
  categoria: Categoria;
  tempoPreparo: number;
  porcoes: number;
  ingredientes: string[];
  modoPreparo: string;
  dataCadastro: string;
}

export interface RecipeRequest {
  nome: string;
  categoria: Categoria | '';
  tempoPreparo: number | null;
  porcoes: number | null;
  ingredientes: string[];
  modoPreparo: string;
}
