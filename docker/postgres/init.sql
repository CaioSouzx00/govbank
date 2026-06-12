-- ============================================================================
-- GOVBANK CORE - POSTGRESQL INITIALIZATION SCRIPT
-- Executado automaticamente na primeira inicialização do container
-- ============================================================================

-- Habilitar extensões úteis
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Criar usuários adicionais
DO $$
BEGIN
    -- Usuário de auditoria (read-only)
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'govbank_audit') THEN
        CREATE USER govbank_audit WITH PASSWORD 'Audit@2026!';
    END IF;
    
    -- Usuário COBOL (apenas operações específicas)
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'govbank_cobol') THEN
        CREATE USER govbank_cobol WITH PASSWORD 'Cobol@2026!';
    END IF;
END
$$;

-- Configurar timezone padrão
ALTER DATABASE govbank_core SET timezone TO 'America/Sao_Paulo';

-- Otimizações de performance
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
ALTER SYSTEM SET pg_stat_statements.max = 10000;
ALTER SYSTEM SET pg_stat_statements.track = all;

-- Log de queries lentas (> 1 segundo)
ALTER SYSTEM SET log_min_duration_statement = 1000;

-- Checkpoint menos agressivo (melhor performance)
ALTER SYSTEM SET checkpoint_completion_target = 0.9;

-- Mensagem de confirmação
DO $$
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'GovBank Core PostgreSQL inicializado com sucesso!';
    RAISE NOTICE 'Database: govbank_core';
    RAISE NOTICE 'Timezone: America/Sao_Paulo';
    RAISE NOTICE 'Extensões habilitadas: pg_stat_statements, pgcrypto, uuid-ossp';
    RAISE NOTICE '================================================';
END
$$;