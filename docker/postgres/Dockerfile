# ============================================================================
# GOVBANK CORE - POSTGRESQL CUSTOM IMAGE
# Base: PostgreSQL 16 Alpine (leve e seguro)
# Inclui: pg_stat_statements, timezone BR, locales PT-BR
# ============================================================================

FROM postgres:16-alpine

LABEL maintainer="GovBank Core Team"
LABEL description="PostgreSQL 16 customizado para GovBank Core"
LABEL version="1.0.0"

# ============================================================================
# VARIÁVEIS DE BUILD
# ============================================================================
ARG PG_MAJOR=16
ENV LANG=pt_BR.UTF-8 \
    LANGUAGE=pt_BR:pt \
    LC_ALL=pt_BR.UTF-8 \
    TZ=America/Sao_Paulo

# ============================================================================
# INSTALAÇÃO DE PACOTES E EXTENSÕES
# ============================================================================
RUN apk update && apk add --no-cache \
    # Timezone data
    tzdata \
    # Locales
    musl-locales \
    musl-locales-lang \
    # Ferramentas de administração
    postgresql${PG_MAJOR}-contrib \
    # Cliente psql com suporte a SSL
    postgresql${PG_MAJOR}-client \
    && rm -rf /var/cache/apk/*

# ============================================================================
# CONFIGURAÇÃO DE TIMEZONE
# ============================================================================
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ============================================================================
# CRIAÇÃO DE DIRETÓRIOS
# ============================================================================
RUN mkdir -p /var/log/postgresql && \
    chown -R postgres:postgres /var/log/postgresql

# ============================================================================
# HEALTHCHECK CUSTOMIZADO
# ============================================================================
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=5 \
    CMD pg_isready -U ${POSTGRES_USER:-postgres} -d ${POSTGRES_DB:-govbank_core} || exit 1

# ============================================================================
# EXPOSE
# ============================================================================
EXPOSE 5432

# ============================================================================
# ENTRY POINT (herdado da imagem base)
# ============================================================================
# O entrypoint padrão do postgres:16-alpine já executa:
# - Inicialização do cluster
# - Execução de scripts em /docker-entrypoint-initdb.d/
# - Start do servidor PostgreSQL