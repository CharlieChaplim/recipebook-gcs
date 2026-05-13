package com.recipebook.dto;

import com.recipebook.entity.Categoria;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

public class RecipeRequest {
    @NotBlank(message = "Nome é obrigatório")
    @Size(min = 3, message = "Nome deve ter no mínimo 3 caracteres")
    private String nome;

    @NotNull(message = "Categoria é obrigatória")
    private Categoria categoria;

    @NotNull(message = "Tempo de preparo é obrigatório")
    @Min(value = 1, message = "Tempo de preparo deve ser de no mínimo 1 minuto")
    private Integer tempoPreparo;

    @NotNull(message = "Porções é obrigatório")
    @Min(value = 1, message = "Porções deve ser de no mínimo 1")
    private Integer porcoes;

    @NotEmpty(message = "Informe ao menos 1 ingrediente")
    private List<@NotBlank(message = "Ingrediente não pode ser vazio") String> ingredientes;

    @NotBlank(message = "Modo de preparo é obrigatório")
    @Size(min = 10, message = "Modo de preparo deve ter no mínimo 10 caracteres")
    private String modoPreparo;

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public Categoria getCategoria() { return categoria; }
    public void setCategoria(Categoria categoria) { this.categoria = categoria; }
    public Integer getTempoPreparo() { return tempoPreparo; }
    public void setTempoPreparo(Integer tempoPreparo) { this.tempoPreparo = tempoPreparo; }
    public Integer getPorcoes() { return porcoes; }
    public void setPorcoes(Integer porcoes) { this.porcoes = porcoes; }
    public List<String> getIngredientes() { return ingredientes; }
    public void setIngredientes(List<String> ingredientes) { this.ingredientes = ingredientes; }
    public String getModoPreparo() { return modoPreparo; }
    public void setModoPreparo(String modoPreparo) { this.modoPreparo = modoPreparo; }
}
