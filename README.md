# Gestão de Alunos

Aplicação composta por Flutter (frontend) e Node.js/Express (backend) com persistência em MySQL para cadastro e acompanhamento de alunos.

## Recursos principais

- Dashboard com total de alunos por status.
- Listagem com busca e filtro.
- Cadastro/edição com validação de dados.
- API REST validada com `zod` e camada de repositório para MySQL.

## Requisitos

- Node.js 18+
- Flutter 3.9+
- MySQL 8 (ou compatível)

## Configuração do backend

1. Ajuste o arquivo `backend/.env` (baseado em `env.example`) com as credenciais do banco:
   ```
   PORT=3000
   MYSQL_HOST=localhost
   MYSQL_PORT=3306
   MYSQL_USER=seu_usuario
   MYSQL_PASSWORD=sua_senha
   MYSQL_DATABASE=gestao_alunos
   MYSQL_CONNECTION_LIMIT=10
   ```
2. Certifique-se de que a tabela `alunos` existe (script disponível em nossas instruções anteriores).

## Execução rápida

Com MySQL já disponível, use o script automatizado:

```bash
bash scripts/run_all.sh
```

- Instala dependências e inicia o backend em `http://localhost:3000/api`.
- Roda o Flutter (`flutter run`) definindo `API_BASE_URL` (padrão `http://localhost:3000/api`).
- Ao encerrar o Flutter, o backend é finalizado automaticamente.

### Execução manual (opcional)

```bash
# Backend
cd backend
npm install
npm run dev

# Flutter
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
```

## Estrutura resumida

```
backend/
  src/app.js, server.js
  src/config, controllers, dtos, errors, middlewares, repositories, routes, services

lib/
  config, models, pages, repositories, services

scripts/
  run_all.sh
```

## Rotas da API

- `GET /api/students`
- `POST /api/students`
- `PUT /api/students/:id`
- `DELETE /api/students/:id`
- `DELETE /api/students`
- `POST /api/students/import`