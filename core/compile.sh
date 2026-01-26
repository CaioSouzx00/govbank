#!/bin/bash
# ============================================================================
# GOVBANK CORE - SCRIPT DE COMPILAÇÃO COBOL
# Compila programas usando GnuCOBOL 3.x
# ============================================================================

set -e  # Parar em caso de erro

echo "================================================"
echo "  GovBank COBOL - Compilação de Programas"
echo "================================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Diretórios
SRC_DIR="./src"
BIN_DIR="./bin"
COPYBOOK_DIR="./copybooks"

# Criar diretório bin se não existir
mkdir -p "$BIN_DIR"

# Contador de sucessos/falhas
SUCCESS_COUNT=0
FAIL_COUNT=0

# Função para compilar um programa
compile_program() {
    local program_name=$1
    local source_file="$SRC_DIR/${program_name}.cbl"
    local output_file="$BIN_DIR/$program_name"
    
    echo ""
    echo "──────────────────────────────────────────────"
    echo "Compilando: $program_name"
    echo "──────────────────────────────────────────────"
    
    if [ ! -f "$source_file" ]; then
        echo -e "${RED}✗ Arquivo não encontrado: $source_file${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        return 1
    fi
    
    # Opções de compilação GnuCOBOL
    # -x          : Gerar executável
    # -std=cobol85: Padrão COBOL-85
    # -I          : Diretório de copybooks
    # -Wall       : Todos os warnings
    # -O2         : Otimização nível 2
    
    if cobc -m \
           -std=cobol85 \
           -I "$COPYBOOK_DIR" \
           -Wall \
           -O2 \
           -o "$output_file" \
           "$source_file" 2>&1; then
        
        echo -e "${GREEN}✓ $program_name compilado com sucesso${NC}"
        echo "   Executável: $output_file"
        
        # Mostrar tamanho do executável
        local file_size=$(du -h "$output_file" | cut -f1)
        echo "   Tamanho: $file_size"
        
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        return 0
    else
        echo -e "${RED}✗ Erro ao compilar $program_name${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        return 1
    fi
}

# ============================================================================
# COMPILAÇÃO DOS PROGRAMAS
# ============================================================================

echo ""
echo "Verificando GnuCOBOL..."
if ! command -v cobc &> /dev/null; then
    echo -e "${RED}ERRO: GnuCOBOL não encontrado!${NC}"
    echo "Instale com: sudo apt install gnucobol3"
    exit 1
fi

echo "GnuCOBOL versão:"
cobc --version | head -1

echo ""
echo "Diretório de copybooks: $COPYBOOK_DIR"
echo "Diretório de saída: $BIN_DIR"

# Compilar cada programa
compile_program "GBKUTIL1"
# compile_program "GBKVAL01"  # Descomentar quando criar
# compile_program "GBKCALC1"
# compile_program "GBKPAY01"
# compile_program "GBKCONC1"

# ============================================================================
# RESUMO
# ============================================================================

echo ""
echo "================================================"
echo "  RESUMO DA COMPILAÇÃO"
echo "================================================"
echo -e "Sucessos: ${GREEN}$SUCCESS_COUNT${NC}"
echo -e "Falhas:   ${RED}$FAIL_COUNT${NC}"
echo "================================================"

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ Compilação concluída com sucesso!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠ Compilação concluída com erros.${NC}"
    exit 1
fi
