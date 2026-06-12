      ******************************************************************
      * GOVBANK CORE - ESTRUTURA DE DADOS: TRANSAÇÃO
      * Copybook para registro de transações de pagamento
      ******************************************************************
       01  TRANSACAO-RECORD.
           05  TRX-ID                 PIC 9(15).
           05  TRX-ID-BENEFICIO       PIC 9(9).
           05  TRX-AGENCIA-DEST       PIC X(4).
           05  TRX-CONTA-DEST         PIC X(15).
           05  TRX-COD-BANCO-DEST     PIC X(3).
           05  TRX-VALOR              PIC 9(13)V99.
           05  TRX-DATA-HORA          PIC X(26).
           05  TRX-STATUS             PIC X(12).
               88  TRX-PENDENTE       VALUE 'PENDENTE'.
               88  TRX-PROCESSANDO    VALUE 'PROCESSANDO'.
               88  TRX-CONCLUIDA      VALUE 'CONCLUIDA'.
               88  TRX-ERRO           VALUE 'ERRO'.
               88  TRX-ESTORNADA      VALUE 'ESTORNADA'.
           05  TRX-HASH-AUDITORIA     PIC X(64).
           05  TRX-COD-RETORNO-BANCO  PIC X(10).
