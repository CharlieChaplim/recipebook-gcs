import { Component } from '@angular/core';
import { RouterLink, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, RouterLink],
  template: `
    <header class="topbar">
      <a routerLink="/" class="brand">RecipeBook™</a>
      <nav>
        <a routerLink="/">Receitas</a>
        <a routerLink="/nova" class="button-link">Nova receita</a>
      </nav>
    </header>

    <main class="container">
      <router-outlet />
    </main>
  `
})
export class AppComponent {}
