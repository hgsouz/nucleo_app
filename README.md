# Núcleo

Aplicativo mobile gamificado, feito em **Flutter** (Android, iOS e Web), que ajuda a
população a entender a energia nuclear de forma leve, didática e sem medo.

> Projeto da disciplina Mobile Application Development — **Entrega do 1º Sprint**.

## Integrantes da equipe

<!-- Preencha com o nome e o RM de cada integrante -->
- Nome do integrante 1 — RM 000000
- Nome do integrante 2 — RM 000000
- Nome do integrante 3 — RM 000000

## Empresa / parceiro

**Amazul** — a dor do cliente é a falta de informação sobre energia nuclear para todos
os públicos e o medo que isso gera na população.

## Descrição da solução

O Núcleo transforma o tema "energia nuclear" em jogos curtos, com ranking e convites entre
usuários (com bonificações, como *skins*, em evolução futura).

| Tela | Rota | O que faz |
| --- | --- | --- |
| Home | `/` | Explica o projeto, mostra os benefícios da tecnologia nuclear, os desafios, o nível e o ranking da semana |
| Mito ou Verdade | `/mito` | Cartões de arrastar (direita = verdade, esquerda = mito) com explicação imediata após cada resposta |
| Equilíbrio da Cidade | `/cidade` | O jogador monta a matriz energética e equilibra carbono, custo e estabilidade. Só vence com a energia nuclear como base estável |
| Login / Cadastro | `/login` | Formulário com validação (e-mail, senha, nome e aceite de termos) |
| CRUD de perguntas | `/perguntas` | Cria, edita e exclui as afirmações usadas no jogo Mito ou Verdade |

> Nesta Sprint os dados são **mockados** (ficam apenas em memória). Não há banco de dados
> nem serviços externos.

## Requisitos da Sprint atendidos

- **Navegação entre telas:** `Navigator` com rotas nomeadas (`onGenerateRoute`), 5 telas,
  botão voltar, barra inferior e passagem de parâmetros (nome do usuário enviado do Login
  para a Home via `arguments`; formulário de pergunta recebe a pergunta e devolve os dados
  com `Navigator.pop`).
- **Protótipo visual funcional:** `Scaffold`, `AppBar`/cabeçalho próprio, `Column`, `Row`,
  `Container`, `Padding`, `SizedBox`, `Card`, `Image`, `Icon`, `ListView` e `GridView`,
  com paleta e tipografia padronizadas em `lib/theme`.
- **Gerenciamento de estado:** `StatefulWidget` + `setState()` nos jogos (pontuação,
  carta arrastada, contadores de fontes de energia), no formulário e no login. Um
  `ChangeNotifier` simples (`lib/state/app_state.dart`) só compartilha os dados mockados
  entre as telas (XP, ranking, perguntas).
- **Formulário e validação:** `Form`, `GlobalKey<FormState>`, `TextFormField`, `Checkbox`,
  validações de campo e resposta ao usuário com `SnackBar` e `Dialog`.

## Identidade visual

Paleta com a regra 60/30/10:

| Uso | Cor | Hex |
| --- | --- | --- |
| 60% — fundos e superfícies | Creme | `#FFF5F5` |
| 30% — ações e destaques | Azul | `#1971C2` |
| 10% — contraste e texto | Navy | `#0B1F3A` |

## Como executar

Pré-requisito: [Flutter](https://docs.flutter.dev/get-started/install) instalado
(`flutter doctor` sem erros).

```bash
# 1. Baixar as dependências
flutter pub get

# 2. Executar (emulador Android, simulador iOS, dispositivo ou navegador)
flutter run
flutter run -d chrome   # versão Web
```

Se as pastas `android/`, `ios/` e `web/` ainda não existirem no projeto, gere-as uma única vez:

```bash
flutter create . --project-name nucleo_app --platforms=android,ios,web
```

Testes automatizados:

```bash
flutter test
```

## Estrutura do projeto

```
lib/
├── main.dart              # MaterialApp, rotas e layout responsivo
├── routes.dart            # Nomes das rotas e navegação da barra inferior
├── theme/                 # Paleta de cores e tema
├── models/                # Question, RankEntry
├── data/                  # Dados mockados
├── state/                 # Estado compartilhado entre as telas
├── widgets/               # Botão, cabeçalho, barra inferior e componentes comuns
└── screens/               # Home, jogos, login e CRUD de perguntas
assets/images/logo.png     # Logo do Núcleo
```

## Tecnologias utilizadas

- Flutter e Dart
- Material Design 3
- Git e GitHub (GitHub Classroom)
- Figma (protótipo de interface)

## Vídeo de demonstração

<!-- Cole aqui o link do YouTube (não listado) -->
[Assistir ao vídeo](https://www.youtube.com/)
