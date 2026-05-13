import { bootstrapApplication } from '@angular/platform-browser';
import { provideHttpClient } from '@angular/common/http';
import { provideRouter, Routes } from '@angular/router';
import { AppComponent } from './app/app.component';
import { RecipeListComponent } from './app/pages/recipe-list/recipe-list.component';
import { RecipeFormComponent } from './app/pages/recipe-form/recipe-form.component';
import { RecipeDetailComponent } from './app/pages/recipe-detail/recipe-detail.component';

const routes: Routes = [
  { path: '', component: RecipeListComponent },
  { path: 'nova', component: RecipeFormComponent },
  { path: 'receitas/:id', component: RecipeDetailComponent },
  { path: '**', redirectTo: '' }
];

bootstrapApplication(AppComponent, {
  providers: [provideHttpClient(), provideRouter(routes)]
}).catch(err => console.error(err));
