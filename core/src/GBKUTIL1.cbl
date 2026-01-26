       IDENTIFICATION DIVISION.
       PROGRAM-ID. GBKUTIL1.
      ******************************************************************
      * GOVBANK CORE - BIBLIOTECA DE UTILITARIOS
      * Versao: 1.0.0 - Compativel COBOL-85
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       
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
       
       01  WS-DATE-TIME-VARS.
           05  WS-CURRENT-DATE.
               10  WS-YEAR            PIC 9(4).
               10  WS-MONTH           PIC 9(2).
               10  WS-DAY             PIC 9(2).
           05  WS-CURRENT-TIME.
               10  WS-HOUR            PIC 9(2).
               10  WS-MINUTE          PIC 9(2).
               10  WS-SECOND          PIC 9(2).
           05  WS-TIMESTAMP           PIC X(26).
       
       01  WS-HASH-VARS.
           05  WS-HASH-SEED           PIC 9(15) VALUE 31415926535.
           05  WS-HASH-RESULT         PIC 9(15).
           05  WS-HASH-HEX            PIC X(64).
       
       01  WS-COUNTERS.
           05  WS-I                   PIC 9(2).
           05  WS-J                   PIC 9(2).
           05  WS-LEN                 PIC 9(3).
       
       01  WS-TEMP-VARS.
           05  WS-TEMP-NUM            PIC 9(4).
           05  WS-TEMP-CHAR           PIC X.
       
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
                   PERFORM GET-CURRENT-DATE-PROC
               WHEN 'CALC-HASH'
                   PERFORM CALCULATE-HASH-PROC
               WHEN 'FORMAT-VAL'
                   PERFORM FORMAT-VALUE-PROC
               WHEN OTHER
                   MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
                   MOVE 'FUNCAO INVALIDA' TO LK-OUTPUT-DATA
           END-EVALUATE.
           
           STOP RUN.
       
      ******************************************************************
      * VALIDAR-CPF-PROC
      ******************************************************************
       VALIDAR-CPF-PROC.
           MOVE ZEROS TO WS-CPF-SUM.
           MOVE ZEROS TO WS-CPF-REST.
           
           IF LK-INPUT-DATA(1:11) IS NOT NUMERIC
               MOVE 'INVALIDO - NAO NUMERICO' TO LK-OUTPUT-DATA
               MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
               GO TO VALIDAR-CPF-END
           END-IF.
           
           MOVE LK-INPUT-DATA(1:11) TO WS-CPF-DIGIT.
           
           IF WS-CPF-DIGIT = '00000000000' OR
              WS-CPF-DIGIT = '11111111111' OR
              WS-CPF-DIGIT = '22222222222' OR
              WS-CPF-DIGIT = '33333333333' OR
              WS-CPF-DIGIT = '44444444444' OR
              WS-CPF-DIGIT = '55555555555' OR
              WS-CPF-DIGIT = '66666666666' OR
              WS-CPF-DIGIT = '77777777777' OR
              WS-CPF-DIGIT = '88888888888' OR
              WS-CPF-DIGIT = '99999999999'
               MOVE 'INVALIDO - DIGITOS REPETIDOS' TO LK-OUTPUT-DATA
               MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
               GO TO VALIDAR-CPF-END
           END-IF.
           
           MOVE ZERO TO WS-CPF-SUM.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 9
               COMPUTE WS-CPF-SUM = WS-CPF-SUM +
                   (WS-CPF-DIG(WS-I) * (11 - WS-I))
           END-PERFORM.
           
           DIVIDE WS-CPF-SUM BY 11 GIVING WS-TEMP-NUM
               REMAINDER WS-CPF-REST.
           
           IF WS-CPF-REST < 2
               MOVE 0 TO WS-CPF-DV1
           ELSE
               COMPUTE WS-CPF-DV1 = 11 - WS-CPF-REST
           END-IF.
           
           MOVE ZERO TO WS-CPF-SUM.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10
               COMPUTE WS-CPF-SUM = WS-CPF-SUM +
                   (WS-CPF-DIG(WS-I) * (12 - WS-I))
           END-PERFORM.
           
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
       
      ******************************************************************
      * GET-CURRENT-DATE-PROC
      ******************************************************************
       GET-CURRENT-DATE-PROC.
           ACCEPT WS-CURRENT-DATE FROM DATE.
           ACCEPT WS-CURRENT-TIME FROM TIME.
           
           STRING WS-YEAR DELIMITED BY SIZE
                  '-' DELIMITED BY SIZE
                  WS-MONTH DELIMITED BY SIZE
                  '-' DELIMITED BY SIZE
                  WS-DAY DELIMITED BY SIZE
                  ' ' DELIMITED BY SIZE
                  WS-HOUR DELIMITED BY SIZE
                  ':' DELIMITED BY SIZE
                  WS-MINUTE DELIMITED BY SIZE
                  ':' DELIMITED BY SIZE
                  WS-SECOND DELIMITED BY SIZE
                  INTO WS-TIMESTAMP
           END-STRING.
           
           MOVE WS-TIMESTAMP TO LK-OUTPUT-DATA.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
      ******************************************************************
      * CALCULATE-HASH-PROC
      ******************************************************************
       CALCULATE-HASH-PROC.
           MOVE ZERO TO WS-HASH-RESULT.
           MOVE ZERO TO WS-LEN.
           
           INSPECT LK-INPUT-DATA TALLYING WS-LEN
               FOR CHARACTERS BEFORE INITIAL SPACE.
           
           IF WS-LEN = ZERO
               MOVE 500 TO WS-LEN
           END-IF.
           
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-LEN
               COMPUTE WS-HASH-RESULT =
                   FUNCTION MOD((WS-HASH-RESULT +
                   FUNCTION ORD(LK-INPUT-DATA(WS-I:1)) * WS-I *
                   WS-HASH-SEED), 999999999999999)
           END-PERFORM.
           
           MOVE SPACES TO WS-HASH-HEX.
           STRING 'SHA256-' DELIMITED BY SIZE
                  WS-HASH-RESULT DELIMITED BY SIZE
                  '-SIMULATED-' DELIMITED BY SIZE
                  WS-YEAR DELIMITED BY SIZE
                  WS-MONTH DELIMITED BY SIZE
                  WS-DAY DELIMITED BY SIZE
                  INTO WS-HASH-HEX
           END-STRING.
           
           MOVE WS-HASH-HEX TO LK-OUTPUT-DATA.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
      ******************************************************************
      * FORMAT-VALUE-PROC
      ******************************************************************
       FORMAT-VALUE-PROC.
           STRING 'R$ ' DELIMITED BY SIZE
                  LK-INPUT-DATA DELIMITED BY SPACE
                  INTO LK-OUTPUT-DATA
           END-STRING.
           
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       END PROGRAM GBKUTIL1.
