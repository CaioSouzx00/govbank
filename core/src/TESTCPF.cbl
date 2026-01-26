       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTCPF.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01  WS-CPF                 PIC X(11) VALUE '11144477735'.
       
       PROCEDURE DIVISION.
       
       MAIN-PROCESS.
           DISPLAY 'Testando CPF: ' WS-CPF.
           
           IF WS-CPF IS NUMERIC
               DISPLAY 'CPF e numerico'
           ELSE
               DISPLAY 'CPF NAO e numerico'
           END-IF.
           
           STOP RUN.
       
       END PROGRAM TESTCPF.
