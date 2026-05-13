package com.recipebook.controller;

import com.recipebook.dto.RecipeRequest;
import com.recipebook.entity.Recipe;
import com.recipebook.exception.RecipeNotFoundException;
import com.recipebook.repository.RecipeRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/receitas")
@CrossOrigin(origins = "http://localhost:4200")
public class RecipeController {
    private final RecipeRepository recipeRepository;

    public RecipeController(RecipeRepository recipeRepository) {
        this.recipeRepository = recipeRepository;
    }

    @GetMapping
    public List<Recipe> listar() {
        return recipeRepository.findAllByOrderByDataCadastroDesc();
    }

    @GetMapping("/{id}")
    public Recipe buscarPorId(@PathVariable Long id) {
        return recipeRepository.findById(id).orElseThrow(() -> new RecipeNotFoundException(id));
    }

    @PostMapping
    public ResponseEntity<Recipe> criar(@Valid @RequestBody RecipeRequest request) {
        String nomeNormalizado = request.getNome().trim();
        if (recipeRepository.existsByNomeIgnoreCase(nomeNormalizado)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Já existe uma receita com esse nome");
        }

        Recipe recipe = new Recipe();
        recipe.setNome(nomeNormalizado);
        recipe.setCategoria(request.getCategoria());
        recipe.setTempoPreparo(request.getTempoPreparo());
        recipe.setPorcoes(request.getPorcoes());
        recipe.setIngredientes(request.getIngredientes().stream().map(String::trim).filter(s -> !s.isBlank()).toList());
        recipe.setModoPreparo(request.getModoPreparo().trim());

        return ResponseEntity.status(HttpStatus.CREATED).body(recipeRepository.save(recipe));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable Long id) {
        Recipe recipe = recipeRepository.findById(id).orElseThrow(() -> new RecipeNotFoundException(id));
        recipeRepository.delete(recipe);
        return ResponseEntity.noContent().build();
    }
}
