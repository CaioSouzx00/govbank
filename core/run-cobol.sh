#!/bin/bash
# Script para executar programas COBOL

export COB_LIBRARY_PATH=./bin:$COB_LIBRARY_PATH

if [ -z "$1" ]; then
    echo "Uso: ./run-cobol.sh NOME_PROGRAMA"
    echo "Exemplo: ./run-cobol.sh TESTUTIL"
    exit 1
fi

./bin/$1
