import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormArray, FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { Categoria, RecipeRequest } from '../../models/recipe.model';
import { RecipeService } from '../../services/recipe.service';

@Component({
  selector: 'app-recipe-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: './recipe-form.component.html'
})
export class RecipeFormComponent {
  categorias: Categoria[] = ['DOCE', 'SALGADO', 'BEBIDA', 'SOBREMESA'];
  salvando = false;
  erroApi = '';

  form = this.fb.group({
    nome: ['', [Validators.required, Validators.minLength(3)]],
    categoria: ['', Validators.required],
    tempoPreparo: [null as number | null, [Validators.required, Validators.min(1)]],
    porcoes: [null as number | null, [Validators.required, Validators.min(1)]],
    ingredientes: this.fb.array([this.fb.control('', Validators.required)]),
    modoPreparo: ['', [Validators.required, Validators.minLength(10)]]
  });

  constructor(
    private readonly fb: FormBuilder,
    private readonly recipeService: RecipeService,
    private readonly router: Router
  ) {}

  get ingredientes(): FormArray {
    return this.form.get('ingredientes') as FormArray;
  }

  adicionarIngrediente(): void {
    this.ingredientes.push(this.fb.control('', Validators.required));
  }

  removerIngrediente(index: number): void {
    if (this.ingredientes.length > 1) {
      this.ingredientes.removeAt(index);
    }
  }

  salvar(): void {
    this.erroApi = '';
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const raw = this.form.getRawValue();
    const payload: RecipeRequest = {
      nome: raw.nome?.trim() ?? '',
      categoria: raw.categoria as Categoria,
      tempoPreparo: raw.tempoPreparo,
      porcoes: raw.porcoes,
      ingredientes: (raw.ingredientes ?? []).map(i => i?.trim() ?? '').filter(Boolean),
      modoPreparo: raw.modoPreparo?.trim() ?? ''
    };

    this.salvando = true;
    this.recipeService.criar(payload).subscribe({
      next: () => {
        localStorage.setItem('recipebook-success', 'Receita cadastrada com sucesso!');
        this.router.navigateByUrl('/');
      },
      error: error => {
        this.erroApi = error?.error?.message ?? 'Não foi possível cadastrar a receita.';
        this.salvando = false;
      }
    });
  }

  campoInvalido(nome: string): boolean {
    const campo = this.form.get(nome);
    return !!campo && campo.invalid && (campo.dirty || campo.touched);
  }
}
