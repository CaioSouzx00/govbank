# 🏛️ GovBank Core

> **Sistema Híbrido de Processamento de Benefícios Governamentais com Arquitetura Legado-Moderna**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://openjdk.org/)
[![COBOL](https://img.shields.io/badge/COBOL-GnuCOBOL_3.2-green.svg)](https://gnucobol.sourceforge.io/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.2-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue.svg)](https://www.postgresql.org/)

---

## 📋 Sumário

- [Sobre o Projeto](#-sobre-o-projeto)
- [Contexto de Negócio](#-contexto-de-negócio)
- [Arquitetura](#-arquitetura)
- [Tecnologias](#-tecnologias)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação](#-instalação)
- [Uso](#-uso)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Fluxo de Dados](#-fluxo-de-dados)
- [API Endpoints](#-api-endpoints)
- [Testes](#-testes)
- [Deploy](#-deploy)
- [Roadmap](#-roadmap)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)

---

## 🎯 Sobre o Projeto

**GovBank Core** é um sistema de demonstração profissional que simula o processamento real de benefícios sociais governamentais integrado com infraestrutura bancária, reproduzindo a arquitetura de sistemas críticos como:

- Programas de transferência de renda (ex: Bolsa Família, Auxílio Brasil)
- Sistemas de pagamento do INSS
- Plataformas de repasse do Tesouro Nacional para bancos conveniados

### 🎓 Objetivo Educacional

Este projeto demonstra competências em:

✅ **Arquiteturas Híbridas** - Integração entre sistemas legado (COBOL) e modernos (Java/Spring)  
✅ **Sistemas de Missão Crítica** - Padrões bancários e governamentais  
✅ **Processamento Transacional** - ACID, auditoria, rastreabilidade  
✅ **APIs REST Empresariais** - Documentação OpenAPI, versionamento  
✅ **Infraestrutura como Código** - Docker, scripts de automação  

---

## 🏢 Contexto de Negócio

### Problema

Órgãos governamentais precisam distribuir benefícios sociais para milhões de cidadãos através de múltiplos bancos conveniados, garantindo:

- **Auditabilidade total** (TCU/CGU)
- **Prevenção de fraudes** (CPF duplicados, benefícios indevidos)
- **Rastreamento de cada centavo** (hash criptográfico)
- **Interoperabilidade** bancária (múltiplas instituições)
- **Confiabilidade** (sistemas legado rodando há décadas)

### Solução

Sistema híbrido onde:

1. **API REST moderna** (Java/Spring) expõe serviços para portais cidadãos e órgãos fiscalizadores
2. **Motor COBOL** processa regras críticas (validação, cálculo, geração de pagamentos)
3. **PostgreSQL** armazena dados com triggers de auditoria automática
4. **Arquivos flat** garantem compatibilidade com sistemas bancários legados

---

## 🏗️ Arquitetura

### Visão Geral

```
┌─────────────────────────────────────────────────────────────┐
│                    CAMADAS DO SISTEMA                        │
└─────────────────────────────────────────────────────────────┘

┌──────────────────┐
│   Portais Web    │  (Cidadãos, Gestores, Auditores)
│   Mobile Apps    │
└────────┬─────────┘
         │ HTTPS/REST
         ↓
┌─────────────────────────────────────────────────────────────┐
│  API Layer (Java + Spring Boot)                             │
│  ├─ Controllers (REST)                                      │
│  ├─ Services (Business Logic)                               │
│  ├─ Security (JWT, OAuth2)                                  │
│  └─ Integration (COBOL Bridge)                              │
└────────┬────────────────────────────────────────────────────┘
         │ JDBC / File I/O
         ↓
┌─────────────────────────────────────────────────────────────┐
│  Processing Core (GnuCOBOL)                                 │
│  ├─ GBKVAL01.cbl → Validação CPF/Elegibilidade             │
│  ├─ GBKCALC1.cbl → Cálculo de Benefícios                   │
│  ├─ GBKPAY01.cbl → Geração de Pagamentos                   │
│  └─ GBKCONC1.cbl → Conciliação Bancária                    │
└────────┬────────────────────────────────────────────────────┘
         │ SQL / File System
         ↓
┌─────────────────────────────────────────────────────────────┐
│  Data Layer (PostgreSQL 16)                                 │
│  ├─ Tabelas Normalizadas (3FN)                              │
│  ├─ Triggers de Auditoria                                   │
│  ├─ Views para Relatórios                                   │
│  └─ Particionamento por Data                                │
└─────────────────────────────────────────────────────────────┘
```

### Padrão de Integração COBOL ↔ Java

**Database as a Bridge Pattern**

```
Java API                    PostgreSQL                  COBOL Program
   │                            │                            │
   ├─► INSERT INTO fila         │                            │
   │   (tipo, payload, status)  │                            │
   │                            │ ◄────────SELECT * ─────────┤
   │                            │   WHERE status='PENDENTE'  │
   │                            │                            │
   │                            │ ────────UPDATE status──────►│
   │                            │   SET 'PROCESSANDO'        │
   │                            │                            │
   │                            │ ◄────INSERT resultado──────┤
   │                            │                            │
   ◄────SELECT resultado────────┤                            │
```

**Vantagens:**
- ✅ Desacoplamento total entre camadas
- ✅ Rastreabilidade completa (cada etapa no banco)
- ✅ Retry automático em caso de falhas
- ✅ Auditoria nativa (PostgreSQL triggers)

---

## 🛠️ Tecnologias

### Backend API
- **Java 17** (LTS)
- **Spring Boot 3.2** (Web, Data JPA, Security)
- **Maven** 3.9+
- **Lombok** (redução de boilerplate)
- **MapStruct** (mapeamento DTO ↔ Entity)

### Core de Processamento
- **GnuCOBOL 3.2** (compilador open-source)
- **COBOL-85 Standard** (compatibilidade com mainframes)
- **File I/O** (SEQ, INDEXED, LINE SEQUENTIAL)

### Banco de Dados
- **PostgreSQL 16**
- **PL/pgSQL** (triggers, functions)
- **JSONB** (payloads flexíveis)

### Infraestrutura
- **Docker & Docker Compose**
- **Git & GitHub**
- **Make** (automação de builds)

### Qualidade
- **JUnit 5** (testes unitários)
- **Testcontainers** (testes de integração)
- **SonarQube** (análise de código)
- **OpenAPI 3.0** (documentação de API)

---

## 📦 Pré-requisitos

### Obrigatórios
- **Java JDK 17+** ([Download](https://adoptium.net/))
- **Maven 3.9+** ([Download](https://maven.apache.org/download.cgi))
- **GnuCOBOL 3.2+** ([Instalação](https://gnucobol.sourceforge.io/))
- **Docker 24+** e **Docker Compose 2.0+** ([Download](https://www.docker.com/))
- **PostgreSQL 16** (via Docker ou local)
- **Git 2.40+**

### Opcionais (Desenvolvimento)
- **IntelliJ IDEA** ou **Eclipse** (Java IDE)
- **VS Code** com extensão COBOL
- **Postman** ou **Insomnia** (testes de API)
- **DBeaver** ou **pgAdmin** (administração de banco)

---

## 🚀 Instalação

### 1. Clone o Repositório

```bash
git clone https://github.com/seu-usuario/govbank-core.git
cd govbank-core
```

### 2. Configure as Variáveis de Ambiente

```bash
cp .env.example .env
# Edite o arquivo .env com suas configurações
```

### 3. Inicialize a Infraestrutura

```bash
# Usando Makefile (recomendado)
make setup

# Ou manualmente:
docker-compose -f docker/postgres/docker-compose.yml up -d
```

### 4. Crie o Banco de Dados

```bash
# Aguarde o PostgreSQL iniciar (≈10 segundos)
sleep 10

# Execute o script SQL
psql -h localhost -U govbank_app -d govbank_core -f database/govbank_core.sql
```

### 5. Compile o Projeto

```bash
# Compilar API Java
make build-api

# Compilar programas COBOL
make build-cobol

# Ou tudo de uma vez
make build-all
```

### 6. Execute a Aplicação

```bash
# Terminal 1: API Java
make run-api

# Terminal 2: Verificar banco
make db-logs
```

---

## 💻 Uso

### Iniciando o Sistema Completo

```bash
# Subir toda a infraestrutura
make docker-up

# Acompanhar logs
make docker-logs
```

### Exemplos de API

#### Cadastrar um Cidadão

```bash
curl -X POST http://localhost:8080/api/v1/cidadaos \
  -H "Content-Type: application/json" \
  -d '{
    "cpf": "12345678901",
    "nome": "Maria Silva",
    "dataNascimento": "1985-03-15",
    "rendaFamiliar": 500.00
  }'
```

#### Processar Benefício

```bash
curl -X POST http://localhost:8080/api/v1/beneficios/processar \
  -H "Content-Type: application/json" \
  -d '{
    "cpfCidadao": "12345678901",
    "idPrograma": 1
  }'
```

#### Consultar Transações

```bash
curl http://localhost:8080/api/v1/transacoes?status=CONCLUIDA
```

### Executando Programas COBOL Diretamente

```bash
# Validar lote de CPFs
cd core/bin
./GBKVAL01 < ../data/input/cpf-batch.txt > ../data/output/cpf-result.txt

# Calcular benefícios
./GBKCALC1

# Gerar arquivo de pagamento bancário
./GBKPAY01
```

---

## 📁 Estrutura do Projeto

```
govbank-core/
├── api/                    # Camada REST (Java/Spring Boot)
│   ├── src/main/java/     # Código-fonte
│   ├── src/main/resources/# Configurações
│   ├── src/test/          # Testes
│   └── pom.xml            # Dependências Maven
│
├── core/                   # Motor COBOL
│   ├── src/               # Programas .cbl
│   ├── copybooks/         # Estruturas de dados
│   ├── jcl/               # Jobs batch
│   └── compile.sh         # Script de build
│
├── database/               # Scripts SQL
│   ├── govbank_core.sql   # Schema completo
│   ├── migrations/        # Versionamento DDL
│   └── seeds/             # Dados iniciais
│
├── docker/                 # Containers
│   ├── postgres/          # Banco de dados
│   ├── api/               # API containerizada
│   └── cobol/             # Ambiente COBOL
│
├── docs/                   # Documentação
│   ├── architecture/      # ADRs, diagramas
│   ├── api/               # OpenAPI specs
│   └── manual/            # Guias de uso
│
├── scripts/                # Automações
│   ├── setup/             # Instalação
│   ├── deploy/            # Deploy
│   └── backup/            # Backups
│
├── Makefile               # Comandos automatizados
├── docker-compose.yml     # Orquestração completa
└── README.md              # Este arquivo
```

---

## 🔄 Fluxo de Dados

### 1. Cadastro de Cidadão

```
Portal Cidadão → API REST → PostgreSQL
                               ↓
                          Trigger Auditoria
                               ↓
                          log_auditoria
```

### 2. Processamento de Benefício

```
API REST → INSERT fila_processamento (status: PENDENTE)
              ↓
         COBOL (polling)
              ↓
         SELECT * WHERE status = 'PENDENTE'
              ↓
         UPDATE status = 'PROCESSANDO'
              ↓
         Validar CPF (GBKVAL01.cbl)
              ↓
         Calcular Valor (GBKCALC1.cbl)
              ↓
         INSERT beneficio
              ↓
         UPDATE fila status = 'CONCLUIDO'
              ↓
         API consulta resultado
```

### 3. Geração de Pagamento

```
COBOL (GBKPAY01) → SELECT beneficios ativos
                       ↓
                  Gera arquivo CNAB240
                       ↓
                  INSERT transacao
                       ↓
                  Arquivo enviado ao banco
```

---

## 🌐 API Endpoints

### Cidadãos

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/api/v1/cidadaos` | Cadastrar cidadão |
| `GET` | `/api/v1/cidadaos/{cpf}` | Consultar por CPF |
| `PUT` | `/api/v1/cidadaos/{cpf}` | Atualizar dados |
| `GET` | `/api/v1/cidadaos?status=ATIVO` | Listar por status |

### Benefícios

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/api/v1/beneficios/processar` | Solicitar processamento |
| `GET` | `/api/v1/beneficios/{id}` | Consultar benefício |
| `GET` | `/api/v1/beneficios/cidadao/{cpf}` | Listar por cidadão |

### Transações

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/transacoes` | Listar transações |
| `GET` | `/api/v1/transacoes/{id}` | Detalhes da transação |
| `GET` | `/api/v1/transacoes/audit/{hash}` | Consulta auditoria |

### Auditoria

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/audit/logs` | Logs de auditoria |
| `GET` | `/api/v1/audit/relatorio` | Relatório consolidado |

**Documentação completa:** `http://localhost:8080/swagger-ui.html`

---

## 🧪 Testes

### Testes Unitários

```bash
# API Java
make test-api

# Ou com Maven
cd api && mvn test
```

### Testes de Integração

```bash
# Usa Testcontainers para PostgreSQL
make test-integration
```

### Cobertura de Código

```bash
cd api
mvn jacoco:report
# Relatório em: target/site/jacoco/index.html
```

---

## 🚢 Deploy

### Ambiente de Desenvolvimento

```bash
make deploy-dev
```

### Ambiente de Produção

```bash
make deploy-prod
```

### Backup do Banco

```bash
make backup
```

---

## 🗺️ Roadmap

### ✅ Fase 1 - MVP (Concluído)
- [x] Modelagem de dados
- [x] API REST básica
- [x] Programas COBOL core
- [x] Integração COBOL ↔ Java
- [x] Docker Compose

### 🔄 Fase 2 - Em Desenvolvimento
- [ ] Autenticação JWT
- [ ] Geração de arquivos CNAB 240
- [ ] Dashboard de métricas
- [ ] Testes de carga (JMeter)

### 📋 Fase 3 - Planejado
- [ ] Kafka para processamento assíncrono
- [ ] Kubernetes (Helm Charts)
- [ ] Observabilidade (Prometheus/Grafana)
- [ ] CI/CD (GitHub Actions)

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'feat: Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

**Padrão de commits:** [Conventional Commits](https://www.conventionalcommits.org/)

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👤 Autor

**Caio Daniel Souza**
- GitHub: [@seu-usuario](https://github.com/CaioSouzx00)

---

## 📚 Referências

- [Documentação Spring Boot](https://spring.io/projects/spring-boot)
- [GnuCOBOL Programming Guide](https://gnucobol.sourceforge.io/doc/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [FEBRABAN - Padrão CNAB](https://portal.febraban.org.br/pagina/3053/33/pt-br/layout-240)
- [Manual de Auditoria do TCU](https://portal.tcu.gov.br/)

---

<div align="center">
  <strong>Desenvolvido para demonstrar competências em sistemas de missão crítica</strong><br>
  <sub>GovBank Core © 2026</sub>
</div>
