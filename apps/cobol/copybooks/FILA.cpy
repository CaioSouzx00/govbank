      ******************************************************************
      * GOVBANK CORE - ESTRUTURA DE DADOS: FILA DE PROCESSAMENTO
      * Copybook para comunicação Java ↔ COBOL via banco de dados
      ******************************************************************
       01  FILA-RECORD.
           05  FILA-ID                PIC 9(15).
           05  FILA-TIPO-OPERACAO     PIC X(20).
               88  FILA-OP-VALIDAR    VALUE 'VALIDAR_CPF'.
               88  FILA-OP-CALCULAR   VALUE 'CALCULAR_BENEFICIO'.
               88  FILA-OP-PAGAR      VALUE 'GERAR_PAGAMENTO'.
               88  FILA-OP-CONCILIAR  VALUE 'CONCILIAR'.
           05  FILA-ID-REFERENCIA     PIC 9(15).
           05  FILA-PAYLOAD-JSON      PIC X(5000).
           05  FILA-STATUS            PIC X(12).
               88  FILA-PENDENTE      VALUE 'PENDENTE'.
               88  FILA-PROCESSANDO   VALUE 'PROCESSANDO'.
               88  FILA-CONCLUIDO     VALUE 'CONCLUIDO'.
               88  FILA-ERRO          VALUE 'ERRO'.
               88  FILA-RETRY         VALUE 'RETRY'.
           05  FILA-DATA-CRIACAO      PIC X(26).
           05  FILA-DATA-PROCESSAM    PIC X(26).
           05  FILA-MENSAGEM-ERRO     PIC X(1000).
           05  FILA-TENTATIVAS        PIC 9(2).
