import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Recipe, RecipeRequest } from '../models/recipe.model';

@Injectable({ providedIn: 'root' })
export class RecipeService {
  private readonly apiUrl = 'http://localhost:8080/api/receitas';

  constructor(private readonly http: HttpClient) {}

  listar(): Observable<Recipe[]> {
    return this.http.get<Recipe[]>(this.apiUrl);
  }

  buscarPorId(id: number): Observable<Recipe> {
    return this.http.get<Recipe>(`${this.apiUrl}/${id}`);
  }

  criar(recipe: RecipeRequest): Observable<Recipe> {
    return this.http.post<Recipe>(this.apiUrl, recipe);
  }

  excluir(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
