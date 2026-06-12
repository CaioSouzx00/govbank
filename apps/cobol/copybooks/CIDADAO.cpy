      ******************************************************************
      * GOVBANK CORE - ESTRUTURA DE DADOS: CIDADÃO
      * Copybook para manipulação de registros de cidadãos
      ******************************************************************
       01  CIDADAO-RECORD.
           05  CID-CPF                PIC X(11).
           05  CID-NOME               PIC X(200).
           05  CID-DATA-NASC          PIC X(10).
           05  CID-RENDA-FAMILIAR     PIC 9(8)V99.
           05  CID-STATUS             PIC X(10).
               88  CID-ATIVO          VALUE 'ATIVO'.
               88  CID-BLOQUEADO      VALUE 'BLOQUEADO'.
               88  CID-SUSPEITO       VALUE 'SUSPEITO'.
               88  CID-INATIVO        VALUE 'INATIVO'.
           05  CID-DATA-CADASTRO      PIC X(26).
           05  CID-DATA-ATUALIZACAO   PIC X(26).
