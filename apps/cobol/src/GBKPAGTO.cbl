       IDENTIFICATION DIVISION.
       PROGRAM-ID. GBKPAGTO.
       AUTHOR. GovBank Core Team.
       DATE-WRITTEN. 2026-06-12.
       REMARKS. Programa de geração de arquivos de remessa para pagamentos.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT REMESSA-FILE ASSIGN TO 'remessa.txt'
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD  REMESSA-FILE.
       01  REMESSA-RECORD              PIC X(400).
       
       WORKING-STORAGE SECTION.
           COPY WSRETURN.
           COPY TRANSACAO.
           COPY CIDADAO.
           COPY BENEFICIO.
       
       01  WS-HEADER-REMESSA.
           05  WS-TIPO-REG             PIC X(1) VALUE '0'.
           05  WS-COD-EMPRESA          PIC X(20) VALUE 'GOVBANK        '.
           05  WS-NOME-EMPRESA         PIC X(30) VALUE 'GOVBANK CORE SYSTEM'.
           05  WS-DATA-GERACAO         PIC X(10).
           05  WS-SEQ-ARQUIVO          PIC 9(6) VALUE 000001.
           05  WS-FILLER               PIC X(333) VALUE SPACES.
       
       01  WS-TRAILER-REMESSA.
           05  WS-TIPO-REG-T           PIC X(1) VALUE '9'.
           05  WS-TOT-REGISTROS        PIC 9(6) VALUE 000000.
           05  WS-TOT-VALOR            PIC 9(15)V99 VALUE 0.00.
           05  WS-FILLER-T             PIC X(378) VALUE SPACES.
       
       01  WS-DETALHE-REMESSA.
           05  WS-TIPO-REG-D           PIC X(1) VALUE '1'.
           05  WS-COD-BANCO            PIC X(3).
           05  WS-AGENCIA              PIC X(4).
           05  WS-CONTA                PIC X(15).
           05  WS-CPF                  PIC X(11).
           05  WS-NOME                 PIC X(40).
           05  WS-VALOR                PIC 9(13)V99.
           05  WS-DATA-PAGTO           PIC X(10).
           05  WS-ID-TRANSACAO         PIC 9(15).
           05  WS-FILLER-D             PIC X(312) VALUE SPACES.
       
       01  WS-COUNTERS.
           05  WS-REG-COUNT            PIC 9(6) VALUE 0.
           05  WS-VALOR-TOTAL          PIC 9(15)V99 VALUE 0.00.
       
       01  WS-DATE-WORK.
           05  WS-CURRENT-DATE        PIC 9(8).
           05  WS-FORMATTED-DATE       PIC X(10).
       
       01  WS-INPUT-LINE               PIC X(500).
       01  WS-EOF                     PIC X VALUE 'N'.
       
       LINKAGE SECTION.
       01  LK-INPUT-FILE              PIC X(100).
       01  LK-OUTPUT-FILE             PIC X(100).
       01  LK-RETURN-CODE             PIC 9(4).
       
       PROCEDURE DIVISION USING LK-INPUT-FILE
                                LK-OUTPUT-FILE
                                LK-RETURN-CODE.
       
       MAIN-PROCESS.
           PERFORM INITIALIZE-PROGRAM.
           PERFORM PROCESS-ARQUIVO.
           PERFORM FINALIZE-PROGRAM.
           STOP RUN.
       
       INITIALIZE-PROGRAM.
           INITIALIZE WS-COUNTERS.
           ACCEPT WS-CURRENT-DATE FROM DATE YYYYMMDD.
           
           STRING WS-CURRENT-DATE(1:4) DELIMITED BY SIZE
                  '-' DELIMITED BY SIZE
                  WS-CURRENT-DATE(5:2) DELIMITED BY SIZE
                  '-' DELIMITED BY SIZE
                  WS-CURRENT-DATE(7:2) DELIMITED BY SIZE
                  INTO WS-FORMATTED-DATE
           END-STRING.
           
           MOVE WS-FORMATTED-DATE TO WS-DATA-GERACAO.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       PROCESS-ARQUIVO.
           OPEN OUTPUT REMESSA-FILE.
           
           PERFORM WRITE-HEADER.
           
           CLOSE REMESSA-FILE.
           OPEN EXTEND REMESSA-FILE.
           
           PERFORM PROCESS-DETALHE UNTIL WS-EOF = 'S'.
           
           PERFORM WRITE-TRAILER.
           
           CLOSE REMESSA-FILE.
       
       WRITE-HEADER.
           WRITE REMESSA-RECORD FROM WS-HEADER-REMESSA.
           ADD 1 TO WS-REG-COUNT.
       
       PROCESS-DETALHE.
           INITIALIZE WS-DETALHE-REMESSA.
           MOVE 'S' TO WS-EOF.
       
       WRITE-TRAILER.
           MOVE WS-REG-COUNT TO WS-TOT-REGISTROS.
           MOVE WS-VALOR-TOTAL TO WS-TOT-VALOR.
           WRITE REMESSA-RECORD FROM WS-TRAILER-REMESSA.
           ADD 1 TO WS-REG-COUNT.
       
       FINALIZE-PROGRAM.
           MOVE WS-RC-SUCCESS TO LK-RETURN-CODE.
       
       END PROGRAM GBKPAGTO.
