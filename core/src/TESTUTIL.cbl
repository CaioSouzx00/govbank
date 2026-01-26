       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTUTIL.
      ******************************************************************
      * PROGRAMA DE TESTE PARA GBKUTIL1
      ******************************************************************
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01  WS-FUNCTION            PIC X(10).
       01  WS-INPUT               PIC X(500).
       01  WS-OUTPUT              PIC X(500).
       01  WS-RETURN-CODE         PIC 9(4).
       
       PROCEDURE DIVISION.
       
       MAIN-PROCESS.
           DISPLAY '========================================'.
           DISPLAY ' TESTE DO GBKUTIL1'.
           DISPLAY '========================================'.
           DISPLAY ' '.
           
      * Teste 1: Validar CPF valido
           DISPLAY 'Teste 1: Validar CPF 12345678909'.
           MOVE 'VALIDA-CPF' TO WS-FUNCTION.
           MOVE '12345678909' TO WS-INPUT.
           CALL 'GBKUTIL1' USING WS-FUNCTION
                                 WS-INPUT
                                 WS-OUTPUT
                                 WS-RETURN-CODE.
           DISPLAY 'Resultado: ' WS-OUTPUT.
           DISPLAY 'Codigo: ' WS-RETURN-CODE.
           DISPLAY ' '.
           
      * Teste 2: Validar CPF invalido
           DISPLAY 'Teste 2: Validar CPF 11111111111'.
           MOVE 'VALIDA-CPF' TO WS-FUNCTION.
           MOVE '11111111111' TO WS-INPUT.
           CALL 'GBKUTIL1' USING WS-FUNCTION
                                 WS-INPUT
                                 WS-OUTPUT
                                 WS-RETURN-CODE.
           DISPLAY 'Resultado: ' WS-OUTPUT.
           DISPLAY 'Codigo: ' WS-RETURN-CODE.
           DISPLAY ' '.
           
      * Teste 3: Obter data atual
           DISPLAY 'Teste 3: Obter data/hora atual'.
           MOVE 'GET-DATE' TO WS-FUNCTION.
           MOVE SPACES TO WS-INPUT.
           CALL 'GBKUTIL1' USING WS-FUNCTION
                                 WS-INPUT
                                 WS-OUTPUT
                                 WS-RETURN-CODE.
           DISPLAY 'Timestamp: ' WS-OUTPUT.
           DISPLAY 'Codigo: ' WS-RETURN-CODE.
           DISPLAY ' '.
           
      * Teste 4: Calcular hash
           DISPLAY 'Teste 4: Calcular hash de "GOVBANK123"'.
           MOVE 'CALC-HASH' TO WS-FUNCTION.
           MOVE 'GOVBANK123' TO WS-INPUT.
           CALL 'GBKUTIL1' USING WS-FUNCTION
                                 WS-INPUT
                                 WS-OUTPUT
                                 WS-RETURN-CODE.
           DISPLAY 'Hash: ' WS-OUTPUT.
           DISPLAY 'Codigo: ' WS-RETURN-CODE.
           DISPLAY ' '.
           
           DISPLAY '========================================'.
           DISPLAY ' TESTES CONCLUIDOS'.
           DISPLAY '========================================'.
           
           STOP RUN.
       
       END PROGRAM TESTUTIL.
