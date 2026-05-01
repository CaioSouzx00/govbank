# ============================================================================
# GOVBANK CORE - GNUCOBOL DOCKERFILE
# Ambiente completo para compilação e execução de programas COBOL
# ============================================================================

FROM debian:bookworm-slim

LABEL maintainer="GovBank Core Team"
LABEL description="GnuCOBOL 3.2 runtime environment"
LABEL version="1.0.0"

# ============================================================================
# VARIÁVEIS DE AMBIENTE
# ============================================================================
ENV DEBIAN_FRONTEND=noninteractive \
    COB_LIBRARY_PATH=/usr/local/lib \
    LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH \
    PATH=/usr/local/bin:$PATH \
    TZ=America/Sao_Paulo

# ============================================================================
# INSTALAÇÃO DE DEPENDÊNCIAS
# ============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Compilador GnuCOBOL
    gnucobol \
    # Bibliotecas necessárias
    libgmp-dev \
    libncurses-dev \
    libdb-dev \
    # PostgreSQL client
    postgresql-client \
    libpq-dev \
    # Utilitários
    curl \
    make \
    cron \
    vim \
    less \
    procps \
    tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    # Limpeza
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ============================================================================
# VERIFICAR INSTALAÇÃO GNUCOBOL
# ============================================================================
RUN cobc --version && \
    cobc --info

# ============================================================================
# CRIAR USUÁRIO COBOL (NÃO-ROOT)
# ============================================================================
RUN groupadd -g 1002 cobol && \
    useradd -u 1002 -g cobol -m -s /bin/bash cobol

# ============================================================================
# ESTRUTURA DE DIRETÓRIOS
# ============================================================================
WORKDIR /app

RUN mkdir -p \
    /app/src \
    /app/copybooks \
    /app/bin \
    /app/data/input \
    /app/data/output \
    /app/logs \
    /app/scripts \
    && chown -R cobol:cobol /app

# ============================================================================
# SCRIPT DE COMPILAÇÃO
# ============================================================================
COPY --chown=cobol:cobol <<'EOF' /app/scripts/compile-all.sh
#!/bin/bash
# ============================================================================
# Compila todos os programas COBOL
# ============================================================================

set -e

echo "================================================"
echo "  GovBank COBOL - Compilação de Programas"
echo "================================================"

cd /app/src

for cbl_file in *.cbl; do
    if [ -f "$cbl_file" ]; then
        program_name="${cbl_file%.cbl}"
        echo "Compilando: $program_name"
        
        cobc -x -std=cobol85 \
             -I /app/copybooks \
             -o /app/bin/$program_name \
             $cbl_file
        
        if [ $? -eq 0 ]; then
            echo "✓ $program_name compilado com sucesso"
        else
            echo "✗ Erro ao compilar $program_name"
            exit 1
        fi
    fi
done

echo "================================================"
echo "  Compilação concluída!"
echo "================================================"
EOF

RUN chmod +x /app/scripts/compile-all.sh

# ============================================================================
# SCRIPT DAEMON (PROCESSAMENTO CONTÍNUO)
# ============================================================================
COPY --chown=cobol:cobol <<'EOF' /app/scripts/cobol-daemon.sh
#!/bin/bash
# ============================================================================
# Daemon que monitora a fila de processamento no PostgreSQL
# ============================================================================

set -e

echo "================================================"
echo "  GovBank COBOL Daemon - Iniciando"
echo "================================================"

# Compilar programas na inicialização
if [ -f /app/scripts/compile-all.sh ]; then
    /app/scripts/compile-all.sh
fi

# Loop infinito de processamento
while true; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Verificando fila de processamento..."
    
    # Aqui seria chamado o programa COBOL que processa a fila
    # Exemplo: /app/bin/GBKVAL01
    
    # Por enquanto, apenas sleep
    sleep 30
done
EOF

RUN chmod +x /app/scripts/cobol-daemon.sh

# ============================================================================
# TROCAR PARA USUÁRIO COBOL
# ============================================================================
USER cobol

# ============================================================================
# HEALTHCHECK
# ============================================================================
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 \
    CMD ps aux | grep -v grep | grep cobol-daemon || exit 1

# ============================================================================
# COMANDO PADRÃO
# ============================================================================
CMD ["/app/scripts/cobol-daemon.sh"]