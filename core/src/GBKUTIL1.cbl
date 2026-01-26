       IDENTIFICATION DIVISION.
       PROGRAM-ID. GBKUTIL1.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
           COPY WSRETURN.
       
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
           DISPLAY 'DEBUG: GBKUTIL1 chamado'.
           DISPLAY 'DEBUG: Funcao = ' LK-FUNCTION-CODE.
           
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
           
           DISPLAY 'DEBUG: Retornando de GBKUTIL1'.
           STOP RUN.
       
       VALIDAR-CPF-PROC.
           DISPLAY 'DEBUG: Validando CPF'.
           
           IF LK-INPUT-DATA(1:11) IS NUMERIC
               MOVE 'VALIDO (TESTE SIMPLES)' TO LK-OUTPUT-DATA
               MOVE WS-RC-SUCCESS TO LK-RETURN-CODE
               DISPLAY 'DEBUG: CPF validado como VALIDO'
           ELSE
               MOVE 'INVALIDO - NAO NUMERICO' TO LK-OUTPUT-DATA
               MOVE WS-RC-INVALID-DATA TO LK-RETURN-CODE
               DISPLAY 'DEBUG: CPF validado como INVALIDO'
           END-IF.
       
       END PROGRAM GBKUTIL1.
