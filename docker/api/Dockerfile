# ============================================================================
# GOVBANK CORE - JAVA API DOCKERFILE
# Multi-stage build para otimização de imagem
# ============================================================================

# ============================================================================
# STAGE 1: BUILD
# ============================================================================
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

LABEL stage=builder

WORKDIR /build

# Copiar apenas pom.xml primeiro (cache de dependências)
COPY pom.xml .

# Baixar dependências (camada cacheável)
RUN mvn dependency:go-offline -B

# Copiar código-fonte
COPY src ./src

# Build da aplicação (skip tests para imagem de produção)
RUN mvn clean package -DskipTests -B && \
    mv target/*.jar app.jar

# ============================================================================
# STAGE 2: RUNTIME
# ============================================================================
FROM eclipse-temurin:17-jre-alpine

LABEL maintainer="GovBank Core Team"
LABEL description="GovBank Core REST API"
LABEL version="1.0.0"

# ============================================================================
# VARIÁVEIS DE AMBIENTE
# ============================================================================
ENV JAVA_OPTS="" \
    SPRING_PROFILES_ACTIVE=docker \
    TZ=America/Sao_Paulo

# ============================================================================
# INSTALAÇÃO DE UTILITÁRIOS
# ============================================================================
RUN apk add --no-cache \
    curl \
    tzdata \
    tini && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ============================================================================
# CRIAR USUÁRIO NÃO-ROOT (SEGURANÇA)
# ============================================================================
RUN addgroup -g 1001 -S govbank && \
    adduser -u 1001 -S govbank -G govbank

# ============================================================================
# ESTRUTURA DE DIRETÓRIOS
# ============================================================================
WORKDIR /app

RUN mkdir -p /app/logs /app/cobol-data && \
    chown -R govbank:govbank /app

# ============================================================================
# COPIAR ARTEFATO DO STAGE ANTERIOR
# ============================================================================
COPY --from=builder --chown=govbank:govbank /build/app.jar /app/app.jar

# ============================================================================
# TROCAR PARA USUÁRIO NÃO-ROOT
# ============================================================================
USER govbank

# ============================================================================
# HEALTHCHECK
# ============================================================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# ============================================================================
# EXPOSE
# ============================================================================
EXPOSE 8080 9090

# ============================================================================
# ENTRYPOINT COM TINI (process reaper)
# ============================================================================
ENTRYPOINT ["/sbin/tini", "--"]

# ============================================================================
# CMD
# ============================================================================
CMD ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]