-- ============================================================================
-- GOVBANK CORE - DATABASE SCHEMA
-- Sistema de Processamento de Benefícios Governamentais
-- Versão: 1.0.0
-- Data: 2026-01-24
-- ============================================================================

-- Criação do banco de dados
CREATE DATABASE govbank_core
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TEMPLATE = template0;

\c govbank_core;

-- ============================================================================
-- TIPOS ENUMERADOS (ENUMS)
-- ============================================================================

CREATE TYPE status_cidadao AS ENUM ('ATIVO', 'BLOQUEADO', 'SUSPEITO', 'INATIVO');
CREATE TYPE status_beneficio AS ENUM ('CONCEDIDO', 'ATIVO', 'SUSPENSO', 'CANCELADO', 'FINALIZADO');
CREATE TYPE tipo_conta AS ENUM ('CORRENTE', 'POUPANCA', 'DIGITAL');
CREATE TYPE status_transacao AS ENUM ('PENDENTE', 'PROCESSANDO', 'CONCLUIDA', 'ERRO', 'ESTORNADA');
CREATE TYPE tipo_operacao AS ENUM ('VALIDAR_CPF', 'CALCULAR_BENEFICIO', 'GERAR_PAGAMENTO', 'CONCILIAR');
CREATE TYPE status_fila AS ENUM ('PENDENTE', 'PROCESSANDO', 'CONCLUIDO', 'ERRO', 'RETRY');
CREATE TYPE operacao_audit AS ENUM ('INSERT', 'UPDATE', 'DELETE');

-- ============================================================================
-- TABELA: CIDADAO
-- Armazena dados dos cidadãos elegíveis a benefícios
-- ============================================================================

CREATE TABLE cidadao (
    cpf                 VARCHAR(11) PRIMARY KEY,
    nome                VARCHAR(200) NOT NULL,
    data_nascimento     DATE NOT NULL,
    renda_familiar      DECIMAL(10,2) DEFAULT 0.00,
    status              status_cidadao DEFAULT 'ATIVO',
    data_cadastro       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_cpf_valido CHECK (LENGTH(cpf) = 11 AND cpf ~ '^[0-9]+$'),
    CONSTRAINT chk_data_nascimento CHECK (data_nascimento < CURRENT_DATE),
    CONSTRAINT chk_renda_positiva CHECK (renda_familiar >= 0)
);

COMMENT ON TABLE cidadao IS 'Cadastro de cidadãos elegíveis para programas sociais';
COMMENT ON COLUMN cidadao.cpf IS 'CPF sem máscara (apenas números)';
COMMENT ON COLUMN cidadao.status IS 'ATIVO: pode receber / BLOQUEADO: suspenso / SUSPEITO: sob análise';

CREATE INDEX idx_cidadao_status ON cidadao(status);
CREATE INDEX idx_cidadao_renda ON cidadao(renda_familiar);

-- ============================================================================
-- TABELA: BANCO_CONVENIADO
-- Instituições financeiras parceiras para pagamento
-- ============================================================================

CREATE TABLE banco_conveniado (
    cod_banco           VARCHAR(3) PRIMARY KEY,
    nome_banco          VARCHAR(100) NOT NULL,
    cnpj                VARCHAR(14) NOT NULL UNIQUE,
    status_convenio     BOOLEAN DEFAULT TRUE,
    data_convenio       DATE NOT NULL,
    data_atualizacao    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_cod_banco CHECK (LENGTH(cod_banco) = 3 AND cod_banco ~ '^[0-9]+$'),
    CONSTRAINT chk_cnpj CHECK (LENGTH(cnpj) = 14 AND cnpj ~ '^[0-9]+$')
);

COMMENT ON TABLE banco_conveniado IS 'Bancos autorizados a receber repasses governamentais';
COMMENT ON COLUMN banco_conveniado.cod_banco IS 'Código COMPE do banco (ex: 001=BB, 104=Caixa)';

-- ============================================================================
-- TABELA: CONTA_BANCARIA
-- Contas bancárias dos cidadãos para recebimento
-- ============================================================================

CREATE TABLE conta_bancaria (
    agencia             VARCHAR(4) NOT NULL,
    conta               VARCHAR(15) NOT NULL,
    cpf_titular         VARCHAR(11) NOT NULL,
    cod_banco           VARCHAR(3) NOT NULL,
    tipo_conta          tipo_conta NOT NULL,
    saldo               DECIMAL(15,2) DEFAULT 0.00,
    data_abertura       DATE NOT NULL,
    status              BOOLEAN DEFAULT TRUE,
    
    PRIMARY KEY (agencia, conta, cod_banco),
    
    CONSTRAINT fk_conta_cidadao FOREIGN KEY (cpf_titular) 
        REFERENCES cidadao(cpf) ON DELETE RESTRICT,
    CONSTRAINT fk_conta_banco FOREIGN KEY (cod_banco) 
        REFERENCES banco_conveniado(cod_banco) ON DELETE RESTRICT,
    CONSTRAINT chk_saldo CHECK (saldo >= 0)
);

COMMENT ON TABLE conta_bancaria IS 'Contas bancárias vinculadas aos cidadãos';

CREATE INDEX idx_conta_cpf ON conta_bancaria(cpf_titular);
CREATE INDEX idx_conta_banco ON conta_bancaria(cod_banco);

-- ============================================================================
-- TABELA: PROGRAMA_SOCIAL
-- Programas de benefícios disponíveis
-- ============================================================================

CREATE TABLE programa_social (
    id                  SERIAL PRIMARY KEY,
    nome_programa       VARCHAR(100) NOT NULL UNIQUE,
    descricao           TEXT,
    valor_base          DECIMAL(10,2) NOT NULL,
    renda_max_elegib    DECIMAL(10,2),
    orgao_resp          VARCHAR(100) NOT NULL,
    ativo               BOOLEAN DEFAULT TRUE,
    data_criacao        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_valor_base CHECK (valor_base > 0)
);

COMMENT ON TABLE programa_social IS 'Programas de transferência de renda do governo';
COMMENT ON COLUMN programa_social.renda_max_elegib IS 'Renda familiar máxima para elegibilidade';

INSERT INTO programa_social (nome_programa, descricao, valor_base, renda_max_elegib, orgao_resp) 
VALUES 
    ('Auxílio Brasil', 'Programa de transferência de renda', 600.00, 218.00, 'Ministério do Desenvolvimento Social'),
    ('Bolsa Educação', 'Auxílio para famílias com crianças na escola', 200.00, 500.00, 'Ministério da Educação'),
    ('Auxílio Emergencial', 'Apoio temporário em situações de crise', 400.00, NULL, 'Ministério da Economia');

-- ============================================================================
-- TABELA: BENEFICIO
-- Benefícios concedidos a cada cidadão
-- ============================================================================

CREATE TABLE beneficio (
    id                  SERIAL PRIMARY KEY,
    cpf_cidadao         VARCHAR(11) NOT NULL,
    id_programa         INTEGER NOT NULL,
    valor_calculado     DECIMAL(10,2) NOT NULL,
    data_concessao      DATE NOT NULL DEFAULT CURRENT_DATE,
    data_validade       DATE,
    status              status_beneficio DEFAULT 'CONCEDIDO',
    motivo_concessao    TEXT,
    
    CONSTRAINT fk_beneficio_cidadao FOREIGN KEY (cpf_cidadao) 
        REFERENCES cidadao(cpf) ON DELETE RESTRICT,
    CONSTRAINT fk_beneficio_programa FOREIGN KEY (id_programa) 
        REFERENCES programa_social(id) ON DELETE RESTRICT,
    CONSTRAINT chk_valor_calculado CHECK (valor_calculado > 0),
    CONSTRAINT chk_data_validade CHECK (data_validade IS NULL OR data_validade > data_concessao)
);

COMMENT ON TABLE beneficio IS 'Registro de benefícios concedidos aos cidadãos';

CREATE INDEX idx_beneficio_cpf ON beneficio(cpf_cidadao);
CREATE INDEX idx_beneficio_programa ON beneficio(id_programa);
CREATE INDEX idx_beneficio_status ON beneficio(status);

-- ============================================================================
-- TABELA: TRANSACAO
-- Registro de todas as transações de pagamento
-- ============================================================================

CREATE TABLE transacao (
    id                  BIGSERIAL PRIMARY KEY,
    id_beneficio        INTEGER NOT NULL,
    agencia_dest        VARCHAR(4) NOT NULL,
    conta_dest          VARCHAR(15) NOT NULL,
    cod_banco_dest      VARCHAR(3) NOT NULL,
    valor               DECIMAL(15,2) NOT NULL,
    data_hora           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status              status_transacao DEFAULT 'PENDENTE',
    hash_auditoria      VARCHAR(64) NOT NULL,
    cod_retorno_banco   VARCHAR(10),
    
    CONSTRAINT fk_transacao_beneficio FOREIGN KEY (id_beneficio) 
        REFERENCES beneficio(id) ON DELETE RESTRICT,
    CONSTRAINT fk_transacao_conta FOREIGN KEY (agencia_dest, conta_dest, cod_banco_dest) 
        REFERENCES conta_bancaria(agencia, conta, cod_banco) ON DELETE RESTRICT,
    CONSTRAINT chk_valor_positivo CHECK (valor > 0)
);

COMMENT ON TABLE transacao IS 'Log completo de todas as transações de pagamento';
COMMENT ON COLUMN transacao.hash_auditoria IS 'SHA-256 para garantir integridade do registro';

CREATE INDEX idx_transacao_beneficio ON transacao(id_beneficio);
CREATE INDEX idx_transacao_status ON transacao(status);
CREATE INDEX idx_transacao_data ON transacao(data_hora);

-- ============================================================================
-- TABELA: FILA_PROCESSAMENTO
-- Controle de processamento assíncrono (Java ↔ COBOL)
-- ============================================================================

CREATE TABLE fila_processamento (
    id                  BIGSERIAL PRIMARY KEY,
    tipo_operacao       tipo_operacao NOT NULL,
    id_referencia       BIGINT,
    payload_json        JSONB NOT NULL,
    status              status_fila DEFAULT 'PENDENTE',
    data_criacao        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_processamento  TIMESTAMP,
    mensagem_erro       TEXT,
    tentativas          INTEGER DEFAULT 0,
    
    CONSTRAINT chk_tentativas CHECK (tentativas >= 0 AND tentativas <= 3)
);

COMMENT ON TABLE fila_processamento IS 'Fila para processamento assíncrono entre Java e COBOL';
COMMENT ON COLUMN fila_processamento.payload_json IS 'Dados em JSON para o COBOL processar';

CREATE INDEX idx_fila_status ON fila_processamento(status);
CREATE INDEX idx_fila_tipo ON fila_processamento(tipo_operacao);
CREATE INDEX idx_fila_data ON fila_processamento(data_criacao);

-- ============================================================================
-- TABELA: LOG_AUDITORIA
-- Rastreamento completo de todas as operações (TCU/CGU)
-- ============================================================================

CREATE TABLE log_auditoria (
    id                  BIGSERIAL PRIMARY KEY,
    tabela_origem       VARCHAR(50) NOT NULL,
    id_registro         VARCHAR(50) NOT NULL,
    operacao            operacao_audit NOT NULL,
    usuario             VARCHAR(100) DEFAULT 'SYSTEM',
    data_hora           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dados_anteriores    JSONB,
    dados_novos         JSONB,
    ip_origem           INET
);

COMMENT ON TABLE log_auditoria IS 'Auditoria completa para rastreabilidade (compliance TCU/CGU)';

CREATE INDEX idx_audit_tabela ON log_auditoria(tabela_origem);
CREATE INDEX idx_audit_data ON log_auditoria(data_hora);
CREATE INDEX idx_audit_usuario ON log_auditoria(usuario);

-- ============================================================================
-- TRIGGERS DE AUDITORIA
-- ============================================================================

-- Função genérica de auditoria
CREATE OR REPLACE FUNCTION fn_audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO log_auditoria(tabela_origem, id_registro, operacao, dados_anteriores)
        VALUES (TG_TABLE_NAME, OLD.id::TEXT, 'DELETE', row_to_json(OLD));
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO log_auditoria(tabela_origem, id_registro, operacao, dados_anteriores, dados_novos)
        VALUES (TG_TABLE_NAME, NEW.id::TEXT, 'UPDATE', row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO log_auditoria(tabela_origem, id_registro, operacao, dados_novos)
        VALUES (TG_TABLE_NAME, NEW.id::TEXT, 'INSERT', row_to_json(NEW));
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Aplicar triggers nas tabelas críticas
CREATE TRIGGER trg_audit_beneficio
    AFTER INSERT OR UPDATE OR DELETE ON beneficio
    FOR EACH ROW EXECUTE FUNCTION fn_audit_trigger();

CREATE TRIGGER trg_audit_transacao
    AFTER INSERT OR UPDATE OR DELETE ON transacao
    FOR EACH ROW EXECUTE FUNCTION fn_audit_trigger();

-- ============================================================================
-- VIEWS PARA RELATÓRIOS
-- ============================================================================

CREATE VIEW vw_beneficios_ativos AS
SELECT 
    c.cpf,
    c.nome,
    ps.nome_programa,
    b.valor_calculado,
    b.data_concessao,
    b.status
FROM beneficio b
JOIN cidadao c ON b.cpf_cidadao = c.cpf
JOIN programa_social ps ON b.id_programa = ps.id
WHERE b.status = 'ATIVO';

CREATE VIEW vw_transacoes_pendentes AS
SELECT 
    t.id,
    c.nome AS nome_cidadao,
    bc.nome_banco,
    t.valor,
    t.data_hora,
    t.status
FROM transacao t
JOIN beneficio b ON t.id_beneficio = b.id
JOIN cidadao c ON b.cpf_cidadao = c.cpf
JOIN banco_conveniado bc ON t.cod_banco_dest = bc.cod_banco
WHERE t.status IN ('PENDENTE', 'PROCESSANDO');

-- ============================================================================
-- GRANTS (SEGURANÇA)
-- ============================================================================

-- Usuário para a aplicação Java
CREATE USER govbank_app WITH PASSWORD '${DB_PASSWORD:-CHANGE_THIS_PASSWORD_IN_PRODUCTION}';
GRANT CONNECT ON DATABASE govbank_core TO govbank_app;
GRANT USAGE ON SCHEMA public TO govbank_app;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO govbank_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO govbank_app;

-- Usuário READ-ONLY para auditoria/relatórios
CREATE USER govbank_audit WITH PASSWORD '${DB_AUDIT_PASSWORD:-CHANGE_THIS_PASSWORD_IN_PRODUCTION}';
GRANT CONNECT ON DATABASE govbank_core TO govbank_audit;
GRANT USAGE ON SCHEMA public TO govbank_audit;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO govbank_audit;

-- ============================================================================
-- FIM DO SCRIPT
-- ============================================================================