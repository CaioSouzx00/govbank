# GOVBANK - Arquitetura Completa do Sistema

## 📋 Índice
1. [Visão Geral](#visão-geral)
2. [Arquitetura do Sistema](#arquitetura-do-sistema)
3. [Fluxo de Dados](#fluxo-de-dados)
4. [Componentes](#componentes)
5. [Como Iniciar o Projeto](#como-iniciar-o-projeto)
6. [Testando as APIs](#testando-as-apis)
7. [Diagramas](#diagramas)

---

## 🎯 Visão Geral

O **GovBank Core** é um sistema de processamento de benefícios governamentais que combina tecnologias modernas (Java/Spring Boot) com sistemas legados (COBOL) em uma arquitetura híbrida robusta.

### Objetivo Principal
Processar benefícios sociais, validar CPFs, calcular valores, gerar pagamentos e conciliar transações bancárias de forma segura e auditável.

### Stack Tecnológica
- **API**: Java 17 + Spring Boot 3.2.1
- **Banco de Dados**: PostgreSQL 16
- **Processamento**: GnuCOBOL 3.2
- **Orquestração**: Docker Compose
- **Documentação**: SpringDoc OpenAPI (Swagger)
- **Build**: Maven

---

## 🏗️ Arquitetura do Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTE/USUÁRIO                          │
│                   (Browser, Mobile, Outros)                     │
└────────────────────────┬────────────────────────────────────────┘
                         │ HTTP/REST
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API GATEWAY (PORTA 8080)                   │
│                   Spring Boot + Java 17                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ Controllers  │  │   Services   │  │  Repositories│          │
│  │  (REST API)  │  │  (Lógica)    │  │  (JPA/Hibernate)│        │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└────────┬───────────────────────────────────────────┬────────────┘
         │                                           │
         │ JDBC                                      │ Volumes
         ▼                                           ▼
┌─────────────────────────┐         ┌─────────────────────────┐
│   POSTGRESQL (PORTA 5432)│         │   COBOL ENGINE          │
│   - cidadao              │         │   (GnuCOBOL 3.2)        │
│   - beneficio            │◄────────┤   - GBKUTIL1.cbl        │
│   - transacao            │  Fila   │   - TESTCPF.cbl        │
│   - fila_processamento   │         │   - TESTSIMPLES.cbl    │
│   - log_auditoria        │         │   - TESTUTIL.cbl       │
└─────────────────────────┘         └─────────────────────────┘
         │
         │ Volumes
         ▼
┌─────────────────────────┐
│   PERSISTÊNCIA          │
│   (Docker Volumes)      │
└─────────────────────────┘
```

---

## 🔄 Fluxo de Dados

### 1. Fluxo Principal: Validação de CPF e Cálculo de Benefício

```
Cliente → API → PostgreSQL → Fila de Processamento → COBOL → PostgreSQL → API → Cliente
```

**Passo a passo:**

1. **Cliente faz requisição** para validar CPF
   ```
   POST /api/v1/cidadao/validar
   Body: { "cpf": "12345678901" }
   ```

2. **API Spring Boot** recebe a requisição:
   - `CidadaoController` → `CidadaoService` → `CidadaoRepository`
   - Valida formato do CPF
   - Consulta banco de dados

3. **PostgreSQL** retorna dados do cidadão

4. **API insere na fila de processamento** se necessário:
   ```sql
   INSERT INTO fila_processamento (tipo_operacao, payload_json, status)
   VALUES ('VALIDAR_CPF', '{"cpf": "12345678901"}', 'PENDENTE')
   ```

5. **COBOL Engine** (daemon) monitora a fila:
   - Lê registros com status 'PENDENTE'
   - Processa usando programas COBOL (GBKUTIL1, TESTCPF)
   - Atualiza status para 'CONCLUIDO'

6. **API consulta resultado** e retorna para cliente

### 2. Fluxo de Pagamento de Benefício

```
Cliente → API → PostgreSQL → Fila → COBOL → Transação → Banco → API → Cliente
```

**Passo a passo:**

1. Cliente solicita pagamento:
   ```
   POST /api/v1/beneficio/pagar
   Body: { "id_beneficio": 123 }
   ```

2. API cria transação:
   ```sql
   INSERT INTO transacao (id_beneficio, valor, status, ...)
   VALUES (123, 600.00, 'PENDENTE', ...)
   ```

3. API insere na fila:
   ```sql
   INSERT INTO fila_processamento (tipo_operacao, payload_json, status)
   VALUES ('GERAR_PAGAMENTO', '{"id_transacao": 456}', 'PENDENTE')
   ```

4. COBOL processa pagamento:
   - Valida conta bancária
   - Gera arquivo de remessa
   - Atualiza status da transação

5. API retorna confirmação

### 3. Fluxo de Auditoria

```
Qualquer operação → Trigger PostgreSQL → log_auditoria → Consultas TCU/CGU
```

Todas as operações críticas são automaticamente auditadas:
- INSERT/UPDATE/DELETE nas tabelas `beneficio` e `transacao`
- Trigger `fn_audit_trigger()` captura mudanças
- Armazena em `log_auditoria` com dados anteriores e novos

---

## 🧩 Componentes

### 1. API Java (Spring Boot)

**Localização**: `apps/api/`

**Responsabilidades**:
- Expor endpoints REST
- Validar requisições
- Orquestrar lógica de negócio
- Gerenciar transações
- Documentação via Swagger

**Principais Classes**:
- `CidadaoController` - Endpoints de cidadãos
- `BeneficioController` - Endpoints de benefícios
- `TransacaoController` - Endpoints de transações
- `CidadaoService` - Lógica de negócio de cidadãos
- `BeneficioService` - Lógica de benefícios
- `CidadaoRepository` - Acesso a dados (JPA)

**Configurações**:
- `application.yml` - Configuração base
- `application-dev.yml` - Ambiente desenvolvimento
- `application-prod.yml` - Ambiente produção
- `application-docker.yml` - Ambiente Docker

### 2. Banco de Dados PostgreSQL

**Localização**: `database/`

**Responsabilidades**:
- Armazenar dados persistentes
- Garantir integridade referencial
- Executar triggers de auditoria
- Fornecer views para relatórios

**Principais Tabelas**:
- `cidadao` - Cadastro de cidadãos
- `banco_conveniado` - Bancos parceiros
- `conta_bancaria` - Contas dos cidadãos
- `programa_social` - Programas disponíveis
- `beneficio` - Benefícios concedidos
- `transacao` - Histórico de pagamentos
- `fila_processamento` - Fila Java ↔ COBOL
- `log_auditoria` - Auditoria completa

**Views Importantes**:
- `vw_beneficios_ativos` - Benefícios ativos por cidadão
- `vw_transacoes_pendentes` - Transações pendentes

### 3. COBOL Engine

**Localização**: `apps/cobol/`

**Responsabilidades**:
- Processamento batch de benefícios
- Validação de CPF (algoritmos específicos)
- Cálculo de valores (regras complexas)
- Geração de arquivos de remessa
- Conciliação bancária

**Programas COBOL**:
- `GBKUTIL1.cbl` - Utilitários gerais
- `TESTCPF.cbl` - Validação de CPF
- `TESTSIMPLES.cbl` - Operações simples
- `TESTUTIL.cbl` - Testes de utilitários

**Scripts**:
- `compile.sh` - Compila programas COBOL
- `run-cobol.sh` - Executa programa específico

### 4. Docker Orchestration

**Localização**: `docker/` e `docker-compose.yml`

**Responsabilidades**:
- Orquestrar todos os containers
- Gerenciar redes e volumes
- Configurar health checks
- Facilitar deploy

**Services**:
- `postgres` - Banco de dados PostgreSQL
- `api` - API Spring Boot
- `cobol` - Engine COBOL

---

## 🚀 Como Iniciar o Projeto

### Pré-requisitos

- Docker e Docker Compose instalados
- Maven (para build local da API)
- GnuCOBOL 3.x (para desenvolvimento COBOL local)
- Java 17 (para desenvolvimento local)

### Opção 1: Docker Compose (Recomendado)

#### 1. Configurar Variáveis de Ambiente

```bash
cp .env.example .env
# Edite .env se necessário
```

#### 2. Iniciar Todos os Serviços

```bash
make docker-up
# ou
docker compose up -d
```

#### 3. Verificar Status dos Containers

```bash
make docker-ps
# ou
docker compose ps
```

#### 4. Verificar Logs

```bash
# Todos os logs
make docker-logs

# Apenas API
make docker-logs-api

# Apenas COBOL
make docker-logs-cobol

# Apenas PostgreSQL
make docker-logs-db
```

#### 5. Parar Serviços

```bash
make docker-down
# ou
docker compose down
```

### Opção 2: Desenvolvimento Local

#### 1. Iniciar Apenas o Banco de Dados

```bash
make db-start
```

#### 2. Configurar API Local

```bash
cd apps/api
cp src/main/resources/application-dev.yml.example src/main/resources/application-dev.yml
# Edite as configurações de banco de dados
```

#### 3. Executar API Localmente

```bash
make run-api
# ou
cd apps/api && mvn spring-boot:run
```

#### 4. Compilar e Executar COBOL Localmente

```bash
# Compilar
make build-cobol
# ou
cd apps/cobol && ./compile.sh

# Executar programa específico
make run-cobol PROG=TESTCPF
# ou
cd apps/cobol && ./run-cobol.sh TESTCPF
```

### Opção 3: Build Completo

```bash
# Compilar tudo
make build-all

# Compilar apenas API
make build-api

# Compilar apenas COBOL
make build-cobol
```

---

## 🧪 Testando as APIs

### Acessar Swagger UI (Documentação Interativa)

**URL**: http://localhost:8080/swagger-ui.html

**Alternativa**: http://localhost:8080/swagger-ui/index.html

O Swagger UI fornece:
- Documentação completa de todos os endpoints
- Interface interativa para testar requisições
- Exemplos de request/response
- Schema de modelos de dados

### Endpoints Principais

#### 1. Cidadãos

**Listar todos os cidadãos**
```http
GET /api/v1/cidadao
```

**Buscar cidadão por CPF**
```http
GET /api/v1/cidadao/{cpf}
```

**Criar novo cidadão**
```http
POST /api/v1/cidadao
Content-Type: application/json

{
  "cpf": "12345678901",
  "nome": "João Silva",
  "data_nascimento": "1980-01-15",
  "renda_familiar": 1500.00
}
```

**Validar CPF**
```http
POST /api/v1/cidadao/validar
Content-Type: application/json

{
  "cpf": "12345678901"
}
```

#### 2. Benefícios

**Listar benefícios de um cidadão**
```http
GET /api/v1/beneficio/cidadao/{cpf}
```

**Calcular benefício**
```http
POST /api/v1/beneficio/calcular
Content-Type: application/json

{
  "cpf_cidadao": "12345678901",
  "id_programa": 1
}
```

**Conceder benefício**
```http
POST /api/v1/beneficio/conceder
Content-Type: application/json

{
  "cpf_cidadao": "12345678901",
  "id_programa": 1,
  "motivo_concessao": "Elegibilidade comprovada"
}
```

#### 3. Transações

**Listar transações**
```http
GET /api/v1/transacao
```

**Buscar transação por ID**
```http
GET /api/v1/transacao/{id}
```

**Gerar pagamento**
```http
POST /api/v1/transacao/pagar
Content-Type: application/json

{
  "id_beneficio": 123
}
```

**Conciliar transações**
```http
POST /api/v1/transacao/conciliar
Content-Type: application/json

{
  "data_inicio": "2024-01-01",
  "data_fim": "2024-01-31"
}
```

### Testando com cURL

#### Exemplo 1: Criar Cidadão

```bash
curl -X POST http://localhost:8080/api/v1/cidadao \
  -H "Content-Type: application/json" \
  -d '{
    "cpf": "12345678901",
    "nome": "João Silva",
    "data_nascimento": "1980-01-15",
    "renda_familiar": 1500.00
  }'
```

#### Exemplo 2: Validar CPF

```bash
curl -X POST http://localhost:8080/api/v1/cidadao/validar \
  -H "Content-Type: application/json" \
  -d '{
    "cpf": "12345678901"
  }'
```

#### Exemplo 3: Calcular Benefício

```bash
curl -X POST http://localhost:8080/api/v1/beneficio/calcular \
  -H "Content-Type: application/json" \
  -d '{
    "cpf_cidadao": "12345678901",
    "id_programa": 1
  }'
```

### Testando com Postman

1. Importe a coleção (se disponível) ou crie requisições manualmente
2. Configure base URL: `http://localhost:8080`
3. Use os exemplos acima como templates

### Health Checks

**API Health**
```http
GET http://localhost:8080/actuator/health
```

**API Metrics**
```http
GET http://localhost:8080/actuator/metrics
```

**API Info**
```http
GET http://localhost:8080/actuator/info
```

### Acessar Banco de Dados

**Via Docker Compose**:
```bash
make docker-shell-db
# ou
docker compose exec postgres psql -U govbank_app -d govbank_core
```

**Queries úteis**:
```sql
-- Ver cidadãos
SELECT * FROM cidadao LIMIT 10;

-- Ver benefícios ativos
SELECT * FROM vw_beneficios_ativos;

-- Ver transações pendentes
SELECT * FROM vw_transacoes_pendentes;

-- Ver fila de processamento
SELECT * FROM fila_processamento WHERE status = 'PENDENTE';

-- Ver auditoria
SELECT * FROM log_auditoria ORDER BY data_hora DESC LIMIT 10;
```

---

## 📊 Diagramas

### Diagrama de Sequência: Validação de CPF

```
Cliente          API Controller      Service         Repository        PostgreSQL         COBOL
   │                  │                 │                 │                  │              │
   │  POST /validar   │                 │                 │                  │              │
   ├─────────────────►│                 │                 │                  │              │
   │                  │  validarCPF()  │                 │                  │              │
   │                  ├────────────────►│                 │                  │              │
   │                  │                 │  findByCPF()   │                  │              │
   │                  │                 ├────────────────►│                  │              │
   │                  │                 │                 │  SELECT          │              │
   │                  │                 │                 ├─────────────────►│              │
   │                  │                 │                 │  ResultSet       │              │
   │                  │                 │                 │◄─────────────────┤              │
   │                  │                 │  Cidadao        │                  │              │
   │                  │                 │◄────────────────┤                  │              │
   │                  │  Result         │                 │                  │              │
   │                  │◄────────────────┤                 │                  │              │
   │  200 OK          │                 │                 │                  │              │
   │◄─────────────────┤                 │                 │                  │              │
```

### Diagrama de Sequência: Processamento de Pagamento

```
Cliente          API          PostgreSQL        Fila           COBOL        PostgreSQL
   │               │               │               │              │              │
   │ POST /pagar   │               │               │              │              │
   ├──────────────►│               │               │              │              │
   │               │ BEGIN TX      │               │              │              │
   │               ├──────────────►│               │              │              │
   │               │ INSERT trans  │               │              │              │
   │               ├──────────────►│               │              │              │
   │               │ INSERT fila   │               │              │              │
   │               ├──────────────►│               │              │              │
   │               │ COMMIT        │               │              │              │
   │               ├──────────────►│               │              │              │
   │ 202 Accepted  │               │               │              │              │
   │◄──────────────┤               │               │              │              │
   │               │               │               │              │              │
   │               │               │               │  SELECT PEND │              │
   │               │               │               ├─────────────►│              │
   │               │               │               │  Row         │              │
   │               │               │               │◄─────────────┤              │
   │               │               │               │              │ Processar   │
   │               │               │               │              ├────────────►│
   │               │               │               │              │             │
   │               │               │               │              │ UPDATE fila │
   │               │               │               │◄─────────────┤              │
   │               │               │               │              │ UPDATE trans│
   │               │               │◄──────────────┤              │              │
   │               │               │               │              │              │
```

### Diagrama de Entidade-Relacionamento (Simplificado)

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│   cidadao    │       │   beneficio  │       │  transacao   │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ cpf (PK)     │◄──────│ cpf_cidadao  │◄──────│ id_beneficio │
│ nome         │       │ id_programa  │       │ agencia_dest │
│ data_nasc    │       │ valor_calc   │       │ conta_dest   │
│ renda_fam    │       │ status       │       │ valor        │
│ status       │       │ data_conc    │       │ status       │
└──────────────┘       └──────────────┘       └──────────────┘
       │                       │                       │
       │                       │                       │
       ▼                       ▼                       ▼
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│conta_bancaria│       │programa_soc  │       │banco_conv    │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ agencia (PK) │       │ id (PK)      │       │ cod (PK)     │
│ conta (PK)   │       │ nome_prog    │       │ nome_banco   │
│ cod_banco(PK)│       │ valor_base   │       │ cnpj         │
│ cpf_titular  │       │ renda_max    │       │ status       │
└──────────────┘       └──────────────┘       └──────────────┘
```

### Diagrama de Deploy

```
┌─────────────────────────────────────────────────────────────┐
│                    DOCKER HOST / SERVER                      │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              DOCKER COMPOSE                          │   │
│  │                                                      │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │   │
│  │  │  postgres   │  │     api     │  │    cobol    │  │   │
│  │  │   :5432     │  │   :8080     │  │   (daemon)  │  │   │
│  │  │             │  │             │  │             │  │   │
│  │  │  ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │  │   │
│  │  │  │  Data   │ │  │ │ Spring  │ │  │ │ GnuCOBOL│ │  │   │
│  │  │  │  Volume │ │  │ │  Boot   │ │  │ │  3.2    │ │  │   │
│  │  │  └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │  │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │   │
│  │         │                │                │          │   │
│  │         └────────────────┼────────────────┘          │   │
│  │                          │                           │   │
│  │              ┌───────────▼────────────┐               │   │
│  │              │  govbank-network      │               │   │
│  │              │  (172.28.0.0/16)     │               │   │
│  │              └──────────────────────┘               │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              VOLUMES PERSISTENTES                    │   │
│  │  - postgres-data                                     │   │
│  │  - cobol-data                                        │   │
│  │  - api-logs                                          │   │
│  │  - cobol-logs                                        │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
         │
         │ Portas Expostas
         ▼
┌─────────────────────────────────────────────────────────────┐
│                      EXTERNO                                │
│                                                              │
│  - http://localhost:8080  → API (Swagger, Endpoints)        │
│  - http://localhost:5432  → PostgreSQL (direto)             │
│  - http://localhost:9090  → Actuator/Metrics                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Comandos Makefile Úteis

```bash
# Ajuda
make help

# Setup inicial
make setup

# Banco de dados
make db-start      # Inicia apenas PostgreSQL
make db-stop       # Para PostgreSQL
make db-reset      # Reseta o banco (CUIDADO!)

# Build
make build-api      # Compila API Java
make build-cobol    # Compila programas COBOL
make build-all      # Compila tudo

# Execução
make run-api        # Executa API localmente
make run-cobol      # Executa COBOL (use PROG=nome)

# Testes
make test-api       # Roda testes da API
make test-integration  # Roda testes de integração

# Docker
make docker-build   # Constrói imagens
make docker-up      # Sobe containers
make docker-down    # Para containers
make docker-logs    # Ver logs
make docker-ps      # Lista containers
make docker-clean   # Limpa tudo

# Limpeza
make clean          # Limpa builds
```

---

## 📝 Estrutura de Arquivos

```
govbank/
├── apps/                      # Aplicações
│   ├── api/                   # API Spring Boot
│   │   ├── src/
│   │   │   ├── main/
│   │   │   │   ├── java/com/govbank/api/
│   │   │   │   │   ├── controller/
│   │   │   │   │   ├── service/
│   │   │   │   │   ├── repository/
│   │   │   │   │   ├── model/
│   │   │   │   │   └── GovBankApiApplication.java
│   │   │   │   └── resources/
│   │   │   │       ├── application.yml
│   │   │   │       ├── application-dev.yml
│   │   │   │       └── application-prod.yml
│   │   │   └── test/
│   │   └── pom.xml
│   └── cobol/                 # Engine COBOL
│       ├── src/               # Programas .cbl
│       ├── copybooks/         # Copybooks .cpy
│       ├── bin/               # Binários compilados
│       ├── data/              # Arquivos de dados
│       ├── compile.sh         # Script de compilação
│       └── run-cobol.sh       # Script de execução
├── database/                  # Scripts SQL
│   ├── govbank_core.sql      # Schema principal
│   └── seeds/                # Dados de seed
│       └── 01_dev_data.sql
├── docker/                    # Dockerfiles
│   ├── api/Dockerfile
│   ├── cobol/Dockerfile
│   └── postgres/
│       ├── Dockerfile
│       └── init.sql
├── docs/                      # Documentação
│   ├── api.md
│   ├── cobol.md
│   ├── database.md
│   ├── PROJECT_STRUCTURE.md
│   └── ARCHITECTURE.md       # Este arquivo
├── scripts/                   # Scripts utilitários
│   ├── test/
│   ├── deploy/
│   └── backup/
├── logs/                      # Logs da aplicação
│   ├── api/
│   ├── cobol/
│   └── postgres/
├── .editorconfig
├── .env.example
├── .gitignore
├── CHANGELOG.md
├── LICENSE
├── Makefile
├── README.md
└── docker-compose.yml
```

---

## 🔒 Segurança e Auditoria

### Auditoria Automática

Todas as operações críticas são auditadas automaticamente via triggers PostgreSQL:

- **Tabelas auditadas**: `beneficio`, `transacao`
- **Operações rastreadas**: INSERT, UPDATE, DELETE
- **Dados capturados**: dados anteriores, dados novos, usuário, timestamp, IP

### Consultas de Auditoria

```sql
-- Auditoria de benefícios
SELECT * FROM log_auditoria 
WHERE tabela_origem = 'beneficio' 
ORDER BY data_hora DESC;

-- Auditoria de transações
SELECT * FROM log_auditoria 
WHERE tabela_origem = 'transacao' 
AND operacao = 'UPDATE';

-- Auditoria por usuário
SELECT * FROM log_auditoria 
WHERE usuario = 'admin' 
ORDER BY data_hora DESC;
```

---

## 🚨 Troubleshooting

### API não inicia

1. Verifique se PostgreSQL está rodando:
   ```bash
   make docker-ps
   ```

2. Verifique logs da API:
   ```bash
   make docker-logs-api
   ```

3. Verifique conexão com banco:
   ```bash
   make docker-shell-db
   ```

### COBOL não processa fila

1. Verifique se container COBOL está rodando:
   ```bash
   docker compose ps cobol
   ```

2. Verifique logs do COBOL:
   ```bash
   make docker-logs-cobol
   ```

3. Verifique fila de processamento:
   ```sql
   SELECT * FROM fila_processamento WHERE status = 'PENDENTE';
   ```

### Erro de conexão com banco

1. Verifique variáveis de ambiente em `.env`
2. Verifique se PostgreSQL está healthy:
   ```bash
   docker compose ps postgres
   ```

3. Teste conexão direta:
   ```bash
   make docker-shell-db
   ```

---

## 📚 Recursos Adicionais

- **Documentação da API**: http://localhost:8080/swagger-ui.html
- **Actuator/Metrics**: http://localhost:8080/actuator
- **PostgreSQL**: localhost:5432
- **Makefile Commands**: `make help`

---

## 🎓 Próximos Passos

1. **Desenvolver endpoints REST** completos em `apps/api/src/main/java/com/govbank/api/controller/`
2. **Implementar lógica de negócio** em `apps/api/src/main/java/com/govbank/api/service/`
3. **Criar programas COBOL** adicionais em `apps/cobol/src/`
4. **Adicionar testes** em `apps/api/src/test/`
5. **Configurar CI/CD** para automação de builds e deploys
6. **Monitoramento** com Prometheus/Grafana (opcional)

---

**Versão**: 1.0.0  
**Última Atualização**: 2026-06-12  
**Maintainer**: GovBank Core Team
