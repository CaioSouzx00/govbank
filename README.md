# 🏛️ GovBank Core

> Sistema híbrido de processamento financeiro-governamental inspirado em arquiteturas reais utilizadas por bancos públicos e órgãos federais brasileiros (Dataprev, SERPRO, Caixa, Banco do Brasil).

---

## 📌 Visão Geral

O **GovBank Core** é um projeto de portfólio profissional que simula um sistema crítico responsável por:

* Processar benefícios sociais
* Validar cidadãos e contas bancárias
* Gerar ordens de pagamento
* Manter trilhas completas de auditoria

A arquitetura combina **tecnologias legadas (COBOL)** com **arquitetura moderna baseada em APIs (Java + Spring Boot)**, utilizando **PostgreSQL** como camada de persistência e rastreabilidade.

Este projeto foi desenhado para refletir padrões encontrados em ambientes de:

* Bancos públicos
* Órgãos governamentais
* Empresas de core bancário
* GovTechs e FinTechs

---

## 🧠 Objetivo Profissional

Demonstrar domínio em:

* Arquitetura híbrida (legado + moderno)
* Sistemas assíncronos baseados em filas
* Rastreabilidade e auditoria financeira
* Organização corporativa de repositórios
* Boas práticas de engenharia de software

---

## 🏗️ Arquitetura do Sistema

### Visão em Camadas

```
┌──────────────────────────────┐
│   API REST (Java)          │
│  Spring Boot              │
│  Auditoria / Consulta    │
└─────────────┬────────────┘
              │
┌─────────────▼────────────┐
│   FILA DE PROCESSAMENTO │
│   (PostgreSQL)          │
└─────────────┬────────────┘
              │
┌─────────────▼────────────┐
│   CORE COBOL            │
│   Regras de Negócio    │
│   Antifraude           │
└─────────────┬────────────┘
              │
┌─────────────▼────────────┐
│   PostgreSQL           │
│   Persistência        │
│   Auditoria           │
└────────────────────────┘
```

---

## 🔄 Fluxo de Processamento

1. A API Java recebe solicitações externas (cidadãos, auditoria, órgãos públicos)
2. Registros são inseridos na tabela `FILA_PROCESSAMENTO`
3. O Core COBOL lê a fila
4. Processa validações e cálculos
5. Atualiza status e gera transações
6. A API expõe os resultados via endpoints REST

---

## 📊 Entidades de Domínio

### Principais Tabelas

* `CIDADAOS`
* `PROGRAMAS_SOCIAIS`
* `BENEFICIOS`
* `TRANSACOES`
* `BANCOS_CONVENIADOS`
* `CONTAS_BANCARIAS`
* `FILA_PROCESSAMENTO`
* `AUDITORIA`

Todas as operações financeiras geram registros de auditoria para rastreamento completo.

---

## 🧰 Stack Tecnológico

| Camada                | Tecnologia              |
| --------------------- | ----------------------- |
| Core de Processamento | COBOL (GnuCOBOL)        |
| API                   | Java 21 + Spring Boot   |
| Banco de Dados        | PostgreSQL 16           |
| Containers            | Docker + Docker Compose |
| Versionamento         | Git + GitHub            |
| IDE                   | VS Code                 |

---

## 📁 Estrutura do Repositório

```
govbank-core/
├── api/                 # API Java Spring Boot
├── core/               # Engine COBOL
├── database/           # DDL, migrations e seeds
├── docker/             # Containers
├── docs/               # Diagramas e documentação
├── logs/               # Logs de execução
├── scripts/            # Scripts de automação
├── README.md
└── Makefile
```

---

## 🚀 Como Executar

### Pré-requisitos

* Ubuntu Linux
* Docker + Docker Compose
* Java 21
* Maven
* GnuCOBOL
* Git

---

### Subir Banco de Dados

```
make up
```

Banco disponível em:

```
localhost:55432
```

Credenciais:

* Usuário: `govadmin`
* Senha: `govpass`
* Database: `govbank`

---

### Executar Core COBOL

```
make core
```

---

### Executar API Java

```
make api
```

---

## 📝 Padrão de Commits

Este projeto segue **Conventional Commits**:

```
feat: adiciona fila de processamento
fix: corrige validação de CPF
docs: atualiza arquitetura
infra: adiciona docker do postgres
```

---

## 🧪 Qualidade e Auditoria

Princípios aplicados:

* Nenhuma transação sem log
* Nenhuma operação sem rastreabilidade
* Separação clara entre API e Core
* Processamento assíncrono

---

## 🛣️ Roadmap

### Sprint 1

* [x] Estrutura do repositório
* [x] Docker PostgreSQL
* [x] Core COBOL inicial
* [x] README Corporativo

### Sprint 2

* [ ] Modelagem física do banco (DDL)
* [ ] Criação da tabela FILA_PROCESSAMENTO
* [ ] API Java base

### Sprint 3

* [ ] Leitor de fila em COBOL
* [ ] Validação de CPF
* [ ] Geração de transações

### Sprint 4

* [ ] Auditoria via API
* [ ] Logs estruturados
* [ ] Relatórios em arquivo batch

---

## 🔐 Aviso Legal

Este projeto é **educacional e demonstrativo**.
Não deve ser utilizado em produção real para processamento financeiro ou governamental.

---

## 👨‍💻 Autor

**Caio Daniel**
Desenvolvedor Backend | Arquitetura de Sistemas | Bancos de Dados

---

> "Sistemas críticos não falham. Eles explicam cada decisão que tomam."
