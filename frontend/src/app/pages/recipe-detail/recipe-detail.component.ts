import { CommonModule } from '@angular/common';
import { Component, OnInit, signal } from '@angular/core';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { Recipe } from '../../models/recipe.model';
import { RecipeService } from '../../services/recipe.service';

@Component({
  selector: 'app-recipe-detail',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './recipe-detail.component.html'
})
export class RecipeDetailComponent implements OnInit {
  receita = signal<Recipe | null>(null);
  carregando = signal(false);
  erro = signal('');
  excluindo = signal(false);

  constructor(
    private readonly route: ActivatedRoute,
    private readonly router: Router,
    private readonly recipeService: RecipeService
  ) {}

  ngOnInit(): void {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    if (!id) {
      this.erro.set('Receita inválida.');
      return;
    }

    this.carregando.set(true);
    this.recipeService.buscarPorId(id).subscribe({
      next: receita => {
        this.receita.set(receita);
        this.carregando.set(false);
      },
      error: () => {
        this.erro.set('Receita não encontrada.');
        this.carregando.set(false);
      }
    });
  }

  excluir(): void {
    const receita = this.receita();
    if (!receita) return;
    const confirmou = confirm(`Deseja realmente excluir a receita "${receita.nome}"?`);
    if (!confirmou) return;

    this.excluindo.set(true);
    this.recipeService.excluir(receita.id).subscribe({
      next: () => {
        localStorage.setItem('recipebook-success', 'Receita excluída com sucesso!');
        this.router.navigateByUrl('/');
      },
      error: () => {
        this.erro.set('Não foi possível excluir a receita.');
        this.excluindo.set(false);
      }
    });
  }
}
