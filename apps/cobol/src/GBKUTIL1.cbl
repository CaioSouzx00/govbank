       IDENTIFICATION DIVISION.
       PROGRAM-ID. GBKUTIL1.
       
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
                   MOVE 'Funcao GET-DATE nao implementada' 
                       TO LK-OUTPUT-DATA
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
       
       END PROGRAM GBKUTIL1.
