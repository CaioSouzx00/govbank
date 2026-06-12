      ******************************************************************
      * GOVBANK CORE - CÓDIGOS DE RETORNO PADRÃO
      * Estrutura compartilhada entre todos os programas COBOL
      ******************************************************************
       01  WS-RETURN-CODE.
           05  WS-RC-SUCCESS          PIC 9(4) VALUE 0000.
           05  WS-RC-WARNING          PIC 9(4) VALUE 0100.
           05  WS-RC-ERROR            PIC 9(4) VALUE 0200.
           05  WS-RC-FATAL            PIC 9(4) VALUE 0300.
           05  WS-RC-DB-ERROR         PIC 9(4) VALUE 0400.
           05  WS-RC-FILE-ERROR       PIC 9(4) VALUE 0500.
           05  WS-RC-INVALID-DATA     PIC 9(4) VALUE 0600.
           05  WS-RC-NOT-FOUND        PIC 9(4) VALUE 0700.
           05  WS-RC-DUPLICATE        PIC 9(4) VALUE 0800.
