       IDENTIFICATION DIVISION.
       PROGRAM-ID. GBKCONC.
       AUTHOR. GovBank Core Team.
       DATE-WRITTEN. 2026-06-12.
       REMARKS. Programa de conciliação bancária.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY WSRETURN.
           COPY TRANSACAO.
       
       01  WS-CONCILIACAO-WORK.
           05  WS-DATA-INICIO         PIC X(10).
           05  WS-DATA-FIM            PIC X(10).
           05  WS-TOT-ENVIADOS        PIC 9(6) VALUE 0.
           05  WS-TOT-CONCILIADOS     PIC 9(6) VALUE 0.
           05  WS-TOT-PENDENTES        PIC 9(6) VALUE 0.
           05  WS-TOT-ERROS            PIC 9(6) VALUE 0.
           05  WS-VALOR-ENVIADO        PIC 9(15)V99 VALUE 0.
           05  WS-VALOR-CONCILIADO     PIC 9(15)V99 VALUE 0.
           05  WS-VALOR-PENDENTE       PIC 9(15)V99 VALUE 0.
       
       01  WS-STATUS-CONTADOR.
           05  WS-STATUS-PENDENTE     PIC 9(6) VALUE 0.
           05  WS-STATUS-PROCESSANDO  PIC 9(6) VALUE 0.
           05  WS-STATUS-CONCLUIDA     PIC 9(6) VALUE 0.
           05  WS-STATUS-ERRO         PIC 9(6) VALUE 0.
           05  WS-STATUS-ESTORNADA    PIC 9(6) VALUE 0.
       
       01  WS-DATE-WORK.
           05  WS-CURRENT-DATE        PIC 9(8).
           05  WS-FORMATTED-DATE       PIC X(10).
       
       01  WS-REPORT-LINE             PIC X(200).
       
       LINKAGE SECTION.
       01  LK-DATA-INICIO             PIC X(10).
       01  LK-DATA-FIM                PIC X(10).
       01  LK-OUTPUT-REPORT           PIC X(2000).
       01  LK-RETURN-CODE            PIC 9(4).
       
       PROCEDURE DIVISION USING LK-DATA-INICIO
                                LK-DATA-FIM
                                LK-OUTPUT-REPORT
                                LK-RETURN-CODE.
       
       MAIN-PROCESS.
           INITIALIZE WS-CONCILIACAO-WORK.
           INITIALIZE WS-STATUS-CONTADOR.
           MOVE LK-DATA-INICIO TO WS-DATA-INICIO.
           MOVE LK-DATA-FIM TO WS-DATA-FIM.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
           
           PERFORM VALIDAR-DATAS.
           IF LK-RETURN-CODE NOT = WS-RC-SUCCESS
               GO TO MAIN-PROCESS-END
           END-IF.
           
           PERFORM GERAR-RELATORIO.
           
       MAIN-PROCESS-END.
           EXIT.
       
       VALIDAR-DATAS.
           IF WS-DATA-INICIO = SPACES OR WS-DATA-FIM = SPACES
               MOVE 'DATAS OBRIGATORIAS' TO LK-OUTPUT-REPORT
               MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
               GO TO VALIDAR-DATAS-END
           END-IF.
       
       VALIDAR-DATAS-END.
           EXIT.
       
       GERAR-RELATORIO.
           INITIALIZE LK-OUTPUT-REPORT.
           
           STRING 'RELATORIO DE CONCILIACAO BANCARIA' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'PERIODO: ' DELIMITED BY SIZE
                  WS-DATA-INICIO DELIMITED BY SIZE
                  ' A ' DELIMITED BY SIZE
                  WS-DATA-FIM DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  '========================================' DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-REPORT
           END-STRING.
           
           STRING 'TOTAL ENVIADOS: ' DELIMITED BY SIZE
                  WS-TOT-ENVIADOS DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'TOTAL CONCILIADOS: ' DELIMITED BY SIZE
                  WS-TOT-CONCILIADOS DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'TOTAL PENDENTES: ' DELIMITED BY SIZE
                  WS-TOT-PENDENTES DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'TOTAL ERROS: ' DELIMITED BY SIZE
                  WS-TOT-ERROS DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'VALOR ENVIADO: R$ ' DELIMITED BY SIZE
                  WS-VALOR-ENVIADO DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'VALOR CONCILIADO: R$ ' DELIMITED BY SIZE
                  WS-VALOR-CONCILIADO DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  'VALOR PENDENTE: R$ ' DELIMITED BY SIZE
                  WS-VALOR-PENDENTE DELIMITED BY SIZE
                  X'0A' DELIMITED BY SIZE
                  INTO LK-OUTPUT-REPORT
           END-STRING.
           
           PERFORM CALCULAR-TAXA-CONCILIACAO.
       
       CALCULAR-TAXA-CONCILIACAO.
           IF WS-TOT-ENVIADOS > 0
               STRING 'TAXA DE CONCILIACAO: ' DELIMITED BY SIZE
                      INTO LK-OUTPUT-REPORT
               END-STRING
           END-IF.
       
       END PROGRAM GBKCONC.
