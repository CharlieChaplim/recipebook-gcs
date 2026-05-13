# RecipeBook v1.0

Sistema web fullstack para gestão de receitas culinárias.

- Backend: Spring Boot 3.x + Java 17 + H2 Database
- Frontend: Angular 18 standalone components, compatível com a exigência Angular 17+
- Backend roda na porta `8080`
- Frontend roda na porta `4200`

## Estrutura

```text
recipebook-fullstack/
├── backend/
│   ├── pom.xml
│   └── src/main/java/com/recipebook/
│       ├── entity/
│       ├── repository/
│       ├── controller/
│       ├── dto/
│       ├── exception/
│       └── config/
└── frontend/
    ├── package.json
    └── src/app/
        ├── models/
        ├── services/
        └── pages/
```

## Como rodar o backend

Pré-requisitos:

- Java 17+
- Maven 3.9+

Entre na pasta do backend:

```bash
cd backend
mvn spring-boot:run
```

API disponível em:

```text
http://localhost:8080/api/receitas
```

Console H2 disponível em:

```text
http://localhost:8080/h2-console
```

Configuração do H2:

```text
JDBC URL: jdbc:h2:mem:recipebook
User: sa
Password: deixe vazio
```

## Como rodar o frontend

Pré-requisitos:

- Node.js 20+
- npm

Entre na pasta do frontend:

```bash
cd frontend
npm install
npm start
```

Aplicação disponível em:

```text
http://localhost:4200
```

## Endpoints da API

### Listar receitas

```http
GET /api/receitas
```

Retorna as receitas ordenadas por data de cadastro, das mais recentes para as mais antigas.

### Buscar receita por ID

```http
GET /api/receitas/{id}
```

Retorna `404` quando a receita não existe.

### Criar receita

```http
POST /api/receitas
Content-Type: application/json
```

Exemplo:

```json
{
  "nome": "Brigadeiro",
  "categoria": "DOCE",
  "tempoPreparo": 30,
  "porcoes": 20,
  "ingredientes": [
    "1 lata de leite condensado",
    "1 colher de sopa de manteiga",
    "3 colheres de sopa de chocolate em pó",
    "Chocolate granulado"
  ],
  "modoPreparo": "Em uma panela, misture o leite condensado, a manteiga e o chocolate em pó. Mexa em fogo médio até desgrudar do fundo. Deixe esfriar e faça bolinhas. Passe no granulado."
}
```

### Excluir receita

```http
DELETE /api/receitas/{id}
```

Retorna `204 No Content` quando a exclusão é concluída.

## Regras implementadas

- Nome único, com verificação case-insensitive.
- Data de cadastro preenchida automaticamente.
- Ingredientes armazenados como lista.
- Categoria restrita ao enum `DOCE`, `SALGADO`, `BEBIDA`, `SOBREMESA`.
- Tempo de preparo mínimo de 1 minuto.
- Porções mínimo de 1.
- Validação de campos no backend e no frontend.
- Busca em tempo real por nome no frontend.
- Confirmação antes da exclusão.

## Observações

A edição de receitas, autenticação, upload de imagens, favoritos e avaliações não foram implementados porque estão fora do escopo da especificação funcional.

## Dupla

Preencha antes de entregar:

- Nome Completo 1:
- Nome Completo 2:
