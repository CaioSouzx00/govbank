       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTSIMPLES.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01  WS-FUNCTION            PIC X(10).
       01  WS-INPUT               PIC X(500).
       01  WS-OUTPUT              PIC X(500).
       01  WS-RETURN-CODE         PIC 9(4).
       
       PROCEDURE DIVISION.
       
       MAIN-PROCESS.
           DISPLAY 'Teste 1: CPF com letras'.
           MOVE 'VALIDA-CPF' TO WS-FUNCTION.
           MOVE 'ABC12345678' TO WS-INPUT.
           CALL 'GBKUTIL1' USING WS-FUNCTION
                                 WS-INPUT
                                 WS-OUTPUT
                                 WS-RETURN-CODE.
           DISPLAY 'Resultado: ' WS-OUTPUT.
           DISPLAY 'Codigo: ' WS-RETURN-CODE.
           DISPLAY ' '.
           
           DISPLAY 'Teste 2: CPF repetido'.
           MOVE 'VALIDA-CPF' TO WS-FUNCTION.
           MOVE '11111111111' TO WS-INPUT.
           CALL 'GBKUTIL1' USING WS-FUNCTION
                                 WS-INPUT
                                 WS-OUTPUT
                                 WS-RETURN-CODE.
           DISPLAY 'Resultado: ' WS-OUTPUT.
           DISPLAY 'Codigo: ' WS-RETURN-CODE.
           
           STOP RUN.
       
       END PROGRAM TESTSIMPLES.
