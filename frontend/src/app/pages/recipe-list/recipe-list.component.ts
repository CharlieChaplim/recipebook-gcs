import { CommonModule } from '@angular/common';
import { Component, OnInit, computed, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { Recipe } from '../../models/recipe.model';
import { RecipeService } from '../../services/recipe.service';

@Component({
  selector: 'app-recipe-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './recipe-list.component.html'
})
export class RecipeListComponent implements OnInit {
  receitas = signal<Recipe[]>([]);
  busca = signal('');
  carregando = signal(false);
  erro = signal('');
  sucesso = signal('');

  receitasFiltradas = computed(() => {
    const termo = this.busca().trim().toLowerCase();
    if (!termo) return this.receitas();
    return this.receitas().filter(receita => receita.nome.toLowerCase().includes(termo));
  });

  constructor(private readonly recipeService: RecipeService) {}

  ngOnInit(): void {
    this.sucesso.set(localStorage.getItem('recipebook-success') ?? '');
    localStorage.removeItem('recipebook-success');
    this.carregarReceitas();
  }

  carregarReceitas(): void {
    this.carregando.set(true);
    this.erro.set('');
    this.recipeService.listar().subscribe({
      next: receitas => {
        this.receitas.set(receitas);
        this.carregando.set(false);
      },
      error: () => {
        this.erro.set('Não foi possível carregar as receitas. Verifique se o backend está rodando na porta 8080.');
        this.carregando.set(false);
      }
    });
  }

  atualizarBusca(valor: string): void {
    this.busca.set(valor);
  }
}
