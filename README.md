# Sistema de Gestão de Alunos

Um sistema moderno e intuitivo para gerenciamento de alunos desenvolvido em Flutter.

## 🚀 Funcionalidades

### Dashboard Principal

- **Estatísticas em tempo real**: Visualização de total de alunos, ativos, inativos e trancados
- **Design moderno**: Interface com gradientes e animações suaves
- **Navegação intuitiva**: Acesso rápido às principais funcionalidades

### Gestão de Alunos

- **Listagem avançada**: Cards com informações detalhadas e status visual
- **Busca inteligente**: Pesquisa por nome, curso ou email
- **Filtros por status**: Visualização de alunos ativos, inativos ou trancados
- **Ações deslizantes**: Editar e excluir com gestos intuitivos
- **Confirmação de exclusão**: Diálogo de confirmação para evitar exclusões acidentais

### Cadastro/Edição

- **Formulário completo**: Nome, idade, email, telefone, curso e status
- **Validações robustas**: Validação de email, telefone, idade e campos obrigatórios
- **Formatação automática**: Telefone formatado automaticamente durante a digitação
- **Feedback visual**: Loading states e mensagens de sucesso/erro
- **Design responsivo**: Interface adaptável para diferentes tamanhos de tela

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework principal
- **SharedPreferences**: Persistência de dados no LocalStorage do navegador
- **Google Fonts**: Tipografia moderna
- **Flutter Slidable**: Ações deslizantes
- **Flutter Staggered Animations**: Animações escalonadas
- **Shimmer**: Efeito de loading

## 📱 Design System

### Cores

- **Primária**: Azul (#2196F3)
- **Status**: Verde (ativo), Laranja (inativo), Vermelho (trancado)
- **Gradientes**: Transições suaves entre cores

### Componentes

- **Cards**: Bordas arredondadas com sombras sutis
- **Botões**: Design Material 3 com estados de loading
- **Inputs**: Campos com ícones e validação visual
- **Animações**: Transições suaves e escalonadas

## 🚀 Como Executar

1. Clone o repositório
2. Execute `flutter pub get` para instalar as dependências
3. Execute `flutter run` para iniciar o aplicativo

## 📋 Estrutura do Projeto

```
lib/
├── main.dart              # Configuração do app e tema
├── models/
│   └── aluno.dart         # Modelo de dados com validações
├── db/
│   ├── database_helper.dart # Interface unificada
│   └── local_storage_helper.dart # Gerenciamento de dados no LocalStorage
└── pages/
    ├── home_page.dart     # Dashboard principal
    ├── alunos_page.dart   # Listagem de alunos
    ├── cadastro_page.dart # Formulário de cadastro/edição
    ├── detalhes_aluno_page.dart # Página de detalhes do aluno
    └── configuracoes_page.dart # Configurações e gerenciamento de dados
```

## ✨ Melhorias Implementadas

- ✅ Interface moderna com Material Design 3
- ✅ Dashboard com estatísticas em tempo real
- ✅ Sistema de busca e filtros avançados
- ✅ Validações robustas de formulário
- ✅ Animações e transições suaves
- ✅ Feedback visual para todas as ações
- ✅ Design responsivo e acessível
- ✅ Confirmações de exclusão
- ✅ Loading states e tratamento de erros
- ✅ Formatação automática de campos
- ✅ Persistência de dados no LocalStorage
- ✅ Página de detalhes do aluno
- ✅ Sistema de exportar/importar dados
- ✅ Gerenciamento completo de dados
- ✅ Sistema inicia zerado (sem dados de exemplo)
