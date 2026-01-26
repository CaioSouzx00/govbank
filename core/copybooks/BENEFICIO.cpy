      ******************************************************************
      * GOVBANK CORE - ESTRUTURA DE DADOS: BENEFÍCIO
      * Copybook para manipulação de benefícios concedidos
      ******************************************************************
       01  BENEFICIO-RECORD.
           05  BEN-ID                 PIC 9(9).
           05  BEN-CPF-CIDADAO        PIC X(11).
           05  BEN-ID-PROGRAMA        PIC 9(9).
           05  BEN-VALOR-CALCULADO    PIC 9(8)V99.
           05  BEN-DATA-CONCESSAO     PIC X(10).
           05  BEN-DATA-VALIDADE      PIC X(10).
           05  BEN-STATUS             PIC X(10).
               88  BEN-CONCEDIDO      VALUE 'CONCEDIDO'.
               88  BEN-ATIVO          VALUE 'ATIVO'.
               88  BEN-SUSPENSO       VALUE 'SUSPENSO'.
               88  BEN-CANCELADO      VALUE 'CANCELADO'.
               88  BEN-FINALIZADO     VALUE 'FINALIZADO'.
           05  BEN-MOTIVO-CONCESSAO   PIC X(500).
