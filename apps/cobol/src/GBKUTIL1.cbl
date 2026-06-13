       IDENTIFICATION DIVISION.
       PROGRAM-ID. GBKUTIL1.
       AUTHOR. GovBank Core Team.
       DATE-WRITTEN. 2026-06-12.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
           COPY WSRETURN.
       
       01  WS-CPF-WORK.
           05  WS-CPF-DIGIT           PIC 9(11).
           05  WS-CPF-ARRAY REDEFINES WS-CPF-DIGIT.
               10  WS-CPF-DIG         PIC 9 OCCURS 11 TIMES.
           05  WS-CPF-SUM             PIC 9(4) VALUE ZERO.
           05  WS-CPF-REST            PIC 9(2) VALUE ZERO.
           05  WS-CPF-DV1             PIC 9 VALUE ZERO.
           05  WS-CPF-DV2             PIC 9 VALUE ZERO.
       
       01  WS-TEMP-VARS.
           05  WS-TEMP-NUM            PIC 9(4).
       
       01  WS-DATE-TIME.
           05  WS-CURRENT-DATE        PIC 9(8).
           05  WS-CURRENT-TIME        PIC 9(8).
           05  WS-FORMATTED-DATE       PIC X(10).
           05  WS-FORMATTED-TIME      PIC X(8).
           05  WS-TIMESTAMP           PIC X(26).
       
       01  WS-HASH-WORK.
           05  WS-HASH-INPUT          PIC X(500).
           05  WS-HASH-LENGTH        PIC 9(3) VALUE ZERO.
           05  WS-HASH-SUM           PIC 9(10) VALUE ZERO.
           05  WS-HASH-RESULT        PIC X(64).
       
       01  WS-BENEFICIO-CALC.
           05  WS-RENDA-FAMILIAR      PIC 9(8)V99.
           05  WS-VALOR-BASE          PIC 9(8)V99.
           05  WS-RENDA-MAX           PIC 9(8)V99.
           05  WS-FACTOR-ADJUST       PIC 9(3)V99 VALUE 1.00.
           05  WS-VALOR-CALCULADO     PIC 9(8)V99.
           05  WS-ELEGIVEL            PIC X VALUE 'N'.
       
       01  WS-PAGAMENTO-WORK.
           05  WS-AGENCIA             PIC X(4).
           05  WS-CONTA               PIC X(15).
           05  WS-COD-BANCO           PIC X(3).
           05  WS-VALOR               PIC 9(13)V99.
           05  WS-LINHA-REMESSA       PIC X(400).
           05  WS-SEQUENCIAL          PIC 9(6) VALUE ZERO.
       
       LINKAGE SECTION.
       01  LK-FUNCTION-CODE           PIC X(10).
       01  LK-INPUT-DATA              PIC X(500).
       01  LK-OUTPUT-DATA             PIC X(500).
       01  LK-RETURN-CODE             PIC 9(4).
       
       PROCEDURE DIVISION USING LK-FUNCTION-CODE
                                LK-INPUT-DATA
                                LK-OUTPUT-DATA
                                LK-RETURN-CODE.
       
       MAIN-PROCESS.
           INITIALIZE LK-OUTPUT-DATA.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
           
           EVALUATE LK-FUNCTION-CODE
               WHEN 'VALIDA-CPF'
                   PERFORM VALIDAR-CPF-PROC
               WHEN 'GET-DATE'
                   PERFORM GET-DATE-PROC
               WHEN 'CALC-HASH'
                   PERFORM CALC-HASH-PROC
               WHEN 'CALC-BENEF'
                   PERFORM CALC-BENEFICIO-PROC
               WHEN 'GERA-REMESSA'
                   PERFORM GERAR-REMESSA-PROC
               WHEN OTHER
                   MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
                   MOVE 'FUNCAO INVALIDA' TO LK-OUTPUT-DATA
           END-EVALUATE.
           
           STOP RUN.
       
       VALIDAR-CPF-PROC.
           MOVE ZEROS TO WS-CPF-SUM.
           MOVE ZEROS TO WS-CPF-REST.
           
           IF LK-INPUT-DATA(1:11) IS NOT NUMERIC
               MOVE 'INVALIDO - NAO NUMERICO' TO LK-OUTPUT-DATA
               MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
               GO TO VALIDAR-CPF-END
           END-IF.
           
           MOVE LK-INPUT-DATA(1:11) TO WS-CPF-DIGIT.
           
           IF WS-CPF-DIG(1) = WS-CPF-DIG(2) AND
              WS-CPF-DIG(2) = WS-CPF-DIG(3) AND
              WS-CPF-DIG(3) = WS-CPF-DIG(4) AND
              WS-CPF-DIG(4) = WS-CPF-DIG(5) AND
              WS-CPF-DIG(5) = WS-CPF-DIG(6) AND
              WS-CPF-DIG(6) = WS-CPF-DIG(7) AND
              WS-CPF-DIG(7) = WS-CPF-DIG(8) AND
              WS-CPF-DIG(8) = WS-CPF-DIG(9) AND
              WS-CPF-DIG(9) = WS-CPF-DIG(10) AND
              WS-CPF-DIG(10) = WS-CPF-DIG(11)
               MOVE 'INVALIDO - DIGITOS REPETIDOS' TO LK-OUTPUT-DATA
               MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
               GO TO VALIDAR-CPF-END
           END-IF.
           
           MOVE ZERO TO WS-CPF-SUM.
            COMPUTE WS-CPF-SUM = 
               WS-CPF-DIG(1) * 10 +
               WS-CPF-DIG(2) * 9 +
               WS-CPF-DIG(3) * 8 +
               WS-CPF-DIG(4) * 7 +
               WS-CPF-DIG(5) * 6 +
               WS-CPF-DIG(6) * 5 +
               WS-CPF-DIG(7) * 4 +
               WS-CPF-DIG(8) * 3 +
               WS-CPF-DIG(9) * 2.
           DIVIDE WS-CPF-SUM BY 11 GIVING WS-TEMP-NUM
               REMAINDER WS-CPF-REST.
           
           IF WS-CPF-REST < 2
               MOVE 0 TO WS-CPF-DV1
           ELSE
               COMPUTE WS-CPF-DV1 = 11 - WS-CPF-REST
           END-IF.
           
           MOVE ZERO TO WS-CPF-SUM.
           COMPUTE WS-CPF-SUM = 
               WS-CPF-DIG(1) * 11 +
               WS-CPF-DIG(2) * 10 +
               WS-CPF-DIG(3) * 9 +
               WS-CPF-DIG(4) * 8 +
               WS-CPF-DIG(5) * 7 +
               WS-CPF-DIG(6) * 6 +
               WS-CPF-DIG(7) * 5 +
               WS-CPF-DIG(8) * 4 +
               WS-CPF-DIG(9) * 3 +
               WS-CPF-DIG(10) * 2.
           DIVIDE WS-CPF-SUM BY 11 GIVING WS-TEMP-NUM
               REMAINDER WS-CPF-REST.
           
           IF WS-CPF-REST < 2
               MOVE 0 TO WS-CPF-DV2
           ELSE
               COMPUTE WS-CPF-DV2 = 11 - WS-CPF-REST
           END-IF.
           
           IF WS-CPF-DIG(10) = WS-CPF-DV1 AND
              WS-CPF-DIG(11) = WS-CPF-DV2
               MOVE 'VALIDO' TO LK-OUTPUT-DATA
               MOVE WS-RC-SUCCESS TO LK-RETURN-CODE
           ELSE
               MOVE 'INVALIDO - DIGITOS VERIFICADORES'
                   TO LK-OUTPUT-DATA
               MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
           END-IF.
       
       VALIDAR-CPF-END.
           EXIT.
       
       GET-DATE-PROC.
           ACCEPT WS-CURRENT-DATE FROM DATE YYYYMMDD.
           ACCEPT WS-CURRENT-TIME FROM TIME.
           
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
           
           MOVE WS-TIMESTAMP TO LK-OUTPUT-DATA.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       GET-DATE-END.
           EXIT.
       
       CALC-HASH-PROC.
           MOVE LK-INPUT-DATA TO WS-HASH-INPUT.
           MOVE ZEROS TO WS-HASH-SUM.
           MOVE SPACES TO WS-HASH-RESULT.
           
           PERFORM VARYING WS-HASH-LENGTH FROM 1 BY 1 
                   UNTIL WS-HASH-LENGTH > LENGTH OF WS-HASH-INPUT
                   OR WS-HASH-INPUT(WS-HASH-LENGTH:1) = SPACE
               COMPUTE WS-HASH-SUM = WS-HASH-SUM + 
                   FUNCTION ORD(WS-HASH-INPUT(WS-HASH-LENGTH:1))
           END-PERFORM.
           
           MOVE WS-HASH-SUM TO WS-HASH-RESULT(1:10).
           MOVE 'HASH-' TO WS-HASH-RESULT(1:5).
           MOVE WS-HASH-SUM TO WS-HASH-RESULT(6:10).
           MOVE WS-HASH-RESULT TO LK-OUTPUT-DATA.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       CALC-HASH-END.
           EXIT.
       
       CALC-BENEFICIO-PROC.
           UNSTRING LK-INPUT-DATA DELIMITED BY ','
               INTO WS-RENDA-FAMILIAR, WS-VALOR-BASE, WS-RENDA-MAX
           END-UNSTRING.
           
           IF WS-RENDA-MAX > 0 AND WS-RENDA-FAMILIAR > WS-RENDA-MAX
               MOVE 'N' TO WS-ELEGIVEL
               MOVE ZEROS TO WS-VALOR-CALCULADO
           ELSE
               MOVE 'S' TO WS-ELEGIVEL
               IF WS-RENDA-FAMILIAR > 0
                   COMPUTE WS-FACTOR-ADJUST = 1.00 - 
                       (WS-RENDA-FAMILIAR / (WS-RENDA-MAX * 2))
               END-IF
               IF WS-FACTOR-ADJUST < 0.50
                   MOVE 0.50 TO WS-FACTOR-ADJUST
               END-IF
               COMPUTE WS-VALOR-CALCULADO = WS-VALOR-BASE * WS-FACTOR-ADJUST
           END-IF.
           
           STRING WS-ELEGIVEL DELIMITED BY SIZE
                  ',' DELIMITED BY SIZE
                  WS-VALOR-CALCULADO DELIMITED BY SIZE
                  INTO LK-OUTPUT-DATA
           END-STRING.
           
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       CALC-BENEFICIO-END.
           EXIT.
       
       GERAR-REMESSA-PROC.
           UNSTRING LK-INPUT-DATA DELIMITED BY ','
               INTO WS-AGENCIA, WS-CONTA, WS-COD-BANCO, WS-VALOR
           END-UNSTRING.
           
           ADD 1 TO WS-SEQUENCIAL.
           
           STRING '001REMESSA' DELIMITED BY SIZE
                  WS-COD-BANCO DELIMITED BY SIZE
                  WS-AGENCIA DELIMITED BY SIZE
                  WS-CONTA DELIMITED BY SIZE
                  WS-VALOR DELIMITED BY SIZE
                  WS-SEQUENCIAL DELIMITED BY SIZE
                  INTO WS-LINHA-REMESSA
           END-STRING.
           
           MOVE WS-LINHA-REMESSA TO LK-OUTPUT-DATA.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       GERAR-REMESSA-END.
           EXIT.
       
       END PROGRAM GBKUTIL1.
