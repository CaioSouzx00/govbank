# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [0.1.0] - 2026-01-25

### Adicionado
- Arquitetura híbrida COBOL + Java + PostgreSQL
- Docker Compose para infraestrutura completa
- Schema de banco de dados normalizado (8 tabelas)
- Triggers automáticos de auditoria
- Makefile com comandos de automação
- Documentação técnica completa no README
- Padrões de commit (Conventional Commits)
- .gitignore configurado para segurança

### Infraestrutura
- PostgreSQL 16 com timezone BR
- Network bridge isolada
- Volumes persistentes
- Healthchecks em todos os serviços

[0.1.0]: https://github.com/seu-usuario/govbank-core/releases/tag/v0.1.0
