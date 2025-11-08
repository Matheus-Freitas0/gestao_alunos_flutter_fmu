# Sistema de Gestão de Alunos

Aplicação de gerenciamento acadêmico desenvolvida em Flutter com foco em usabilidade, consistência visual e persistência local de dados.

## Visão Geral

- Dashboard com indicadores de alunos ativos, inativos e trancados.
- Gestão completa do cadastro de alunos com pesquisa, filtros e ações rápidas.
- Fluxos de cadastro e edição com validações, feedback visual e suporte a diferentes formatos de tela.
- Persistência local utilizando `SharedPreferences`, garantindo funcionamento mesmo offline.

## Principais Funcionalidades

- `Dashboard`: apresenta métricas consolidadas e atalhos para as principais áreas do sistema.
- `Gestão de alunos`: listagem em cartões com status visual, busca por nome/curso/e-mail, filtros por status e ações deslizantes para edição ou exclusão.
- `Cadastro e edição`: formulário validado (nome, idade, e-mail, telefone, curso, status) com máscara automática para telefone e mensagens de sucesso ou erro.
- `Detalhes do aluno`: visualização completa dos dados cadastrais.
- `Configurações`: opções de exportação, importação e limpeza de dados.

## Tecnologias e Bibliotecas

- `Flutter` (Material Design 3) para construção da interface.
- `SharedPreferences` para armazenamento local.
- `Flutter Slidable` para ações deslizantes.
- `Flutter Staggered Animations` e `Shimmer` para transições e estados de carregamento.
- `Google Fonts` para tipografia padronizada.

## Guia de Execução

1. Configure o ambiente Flutter conforme a documentação oficial.
2. Clone este repositório.
3. Instale as dependências com `flutter pub get`.
4. Inicie a aplicação com `flutter run` (emulador ou dispositivo físico).