       IDENTIFICATION DIVISION.
       PROGRAM-ID. GBKBATCH.
       AUTHOR. GovBank Core Team.
       DATE-WRITTEN. 2026-06-12.
       REMARKS. Programa de processamento em lote da fila de processamento.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY WSRETURN.
           COPY FILA.
           COPY CIDADAO.
           COPY BENEFICIO.
           COPY TRANSACAO.
       
       01  WS-BATCH-CONTROL.
           05  WS-TOTAL-PROCESSADOS    PIC 9(6) VALUE 0.
           05  WS-TOTAL-SUCESSO        PIC 9(6) VALUE 0.
           05  WS-TOTAL-ERRO          PIC 9(6) VALUE 0.
           05  WS-TOTAL-RETRY         PIC 9(6) VALUE 0.
           05  WS-START-TIME          PIC 9(8).
           05  WS-END-TIME            PIC 9(8).
           05  WS-ELAPSED-TIME        PIC 9(8).
       
       01  WS-PROCESSING-STATUS.
           05  WS-CURRENT-OP          PIC X(20).
           05  WS-CURRENT-ID          PIC 9(15).
           05  WS-PROCESS-RESULT      PIC X(10).
           05  WS-ERROR-MESSAGE       PIC X(200).
       
       01  WS-DATE-TIME.
           05  WS-CURRENT-DATE        PIC 9(8).
           05  WS-CURRENT-TIME        PIC 9(8).
           05  WS-FORMATTED-DATE       PIC X(10).
           05  WS-FORMATTED-TIME      PIC X(8).
           05  WS-TIMESTAMP           PIC X(26).
       
       01  WS-FUNCTION-CODE          PIC X(10).
       01  WS-INPUT-DATA             PIC X(500).
       01  WS-OUTPUT-DATA            PIC X(500).
       01  WS-RETURN-CODE            PIC 9(4).
       
       LINKAGE SECTION.
       01  LK-BATCH-TYPE             PIC X(20).
       01  LK-MAX-RECORDS            PIC 9(6).
       01  LK-OUTPUT-LOG             PIC X(2000).
       01  LK-RETURN-CODE            PIC 9(4).
       
       PROCEDURE DIVISION USING LK-BATCH-TYPE
                                LK-MAX-RECORDS
                                LK-OUTPUT-LOG
                                LK-RETURN-CODE.
       
       MAIN-PROCESS.
           PERFORM INITIALIZE-BATCH.
           PERFORM PROCESS-BATCH.
           PERFORM FINALIZE-BATCH.
           STOP RUN.
       
       INITIALIZE-BATCH.
           INITIALIZE WS-BATCH-CONTROL.
           INITIALIZE WS-PROCESSING-STATUS.
           ACCEPT WS-START-TIME FROM TIME.
           ACCEPT WS-CURRENT-DATE FROM DATE YYYYMMDD.
           ACCEPT WS-CURRENT-TIME FROM TIME.
           
           PERFORM FORMAT-TIMESTAMP.
           
           STRING 'INICIO DO BATCH: ' DELIMITED BY SIZE
                  LK-BATCH-TYPE DELIMITED BY SIZE
                  ' AS ' DELIMITED BY SIZE
                  WS-TIMESTAMP DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-LOG
           END-STRING.
           
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       FORMAT-TIMESTAMP.
           STRING WS-CURRENT-DATE(1:4) DELIMITED BY SIZE
                  '-' DELIMITED BY SIZE
                  WS-CURRENT-DATE(5:2) DELIMITED BY SIZE
                  '-' DELIMITED BY SIZE
                  WS-CURRENT-DATE(7:2) DELIMITED BY SIZE
                  INTO WS-FORMATTED-DATE
           END-STRING.
           
           STRING WS-CURRENT-TIME(1:2) DELIMITED BY SIZE
                  ':' DELIMITED BY SIZE
                  WS-CURRENT-TIME(3:2) DELIMITED BY SIZE
                  ':' DELIMITED BY SIZE
                  WS-CURRENT-TIME(5:2) DELIMITED BY SIZE
                  INTO WS-FORMATTED-TIME
           END-STRING.
           
           STRING WS-FORMATTED-DATE DELIMITED BY SPACE
                  ' ' DELIMITED BY SIZE
                  WS-FORMATTED-TIME DELIMITED BY SPACE
                  INTO WS-TIMESTAMP
           END-STRING.
       
       PROCESS-BATCH.
           EVALUATE LK-BATCH-TYPE
               WHEN 'VALIDAR_CPF'
                   PERFORM PROCESS-CPF-VALIDATION
               WHEN 'CALCULAR_BENEFICIO'
                   PERFORM PROCESS-BENEFIT-CALCULATION
               WHEN 'GERAR_PAGAMENTO'
                   PERFORM PROCESS-PAYMENT-GENERATION
               WHEN 'CONCILIAR'
                   PERFORM PROCESS-RECONCILIATION
               WHEN 'ALL'
                   PERFORM PROCESS-ALL-PENDING
               WHEN OTHER
                   MOVE 'TIPO DE BATCH INVALIDO' TO WS-ERROR-MESSAGE
                   MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
           END-EVALUATE.
       
       PROCESS-CPF-VALIDATION.
           MOVE 'VALIDAR_CPF' TO WS-CURRENT-OP.
           STRING 'PROCESSANDO VALIDACAO DE CPF...' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-LOG
           END-STRING.
           ADD 1 TO WS-TOTAL-PROCESSADOS.
           ADD 1 TO WS-TOTAL-SUCESSO.
       
       PROCESS-BENEFIT-CALCULATION.
           MOVE 'CALCULAR_BENEFICIO' TO WS-CURRENT-OP.
           STRING 'PROCESSANDO CALCULO DE BENEFICIO...' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-LOG
           END-STRING.
           ADD 1 TO WS-TOTAL-PROCESSADOS.
           ADD 1 TO WS-TOTAL-SUCESSO.
       
       PROCESS-PAYMENT-GENERATION.
           MOVE 'GERAR_PAGAMENTO' TO WS-CURRENT-OP.
           STRING 'PROCESSANDO GERACAO DE PAGAMENTO...' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-LOG
           END-STRING.
           ADD 1 TO WS-TOTAL-PROCESSADOS.
           ADD 1 TO WS-TOTAL-SUCESSO.
       
       PROCESS-RECONCILIATION.
           MOVE 'CONCILIAR' TO WS-CURRENT-OP.
           STRING 'PROCESSANDO CONCILIACAO...' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-LOG
           END-STRING.
           ADD 1 TO WS-TOTAL-PROCESSADOS.
           ADD 1 TO WS-TOTAL-SUCESSO.
       
       PROCESS-ALL-PENDING.
           STRING 'PROCESSANDO TODAS OPERACOES PENDENTES...' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-LOG
           END-STRING.
           PERFORM PROCESS-CPF-VALIDATION.
           PERFORM PROCESS-BENEFIT-CALCULATION.
           PERFORM PROCESS-PAYMENT-GENERATION.
           PERFORM PROCESS-RECONCILIATION.
       
       FINALIZE-BATCH.
           ACCEPT WS-END-TIME FROM TIME.
           COMPUTE WS-ELAPSED-TIME = WS-END-TIME - WS-START-TIME.
           
           STRING X'0A' DELIMITED BY SIZE
                  '========================================' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'RESUMO DO BATCH:' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'TOTAL PROCESSADOS: ' DELIMITED BY SIZE
                  WS-TOTAL-PROCESSADOS DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'TOTAL SUCESSO: ' DELIMITED BY SIZE
                  WS-TOTAL-SUCESSO DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'TOTAL ERROS: ' DELIMITED BY SIZE
                  WS-TOTAL-ERRO DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'TOTAL RETRY: ' DELIMITED BY SIZE
                  WS-TOTAL-RETRY DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'TEMPO EXECUCAO: ' DELIMITED BY SIZE
                  WS-ELAPSED-TIME DELIMITED BY SIZE
                  ' SEGUNDOS' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-LOG
           END-STRING.
           
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       END PROGRAM GBKBATCH.
