-- ============================================================================
-- GOVBANK CORE - SEEDS DE DESENVOLVIMENTO
-- Dados iniciais para testes e desenvolvimento
-- ============================================================================

-- Bancos Conveniados
INSERT INTO banco_conveniado (cod_banco, nome_banco, cnpj, status_convenio, data_convenio)
VALUES
    ('001', 'Banco do Brasil',       '00000000000191', true, '2020-01-01'),
    ('104', 'Caixa Econômica Federal','00360305000104', true, '2020-01-01'),
    ('033', 'Banco Santander',       '90400888000142', true, '2021-06-01'),
    ('341', 'Itaú Unibanco',         '60701190000104', true, '2021-06-01'),
    ('237', 'Banco Bradesco',        '60746948000112', true, '2021-06-01'),
    ('260', 'Nu Pagamentos (Nubank)', '18236120000158', true, '2022-03-15')
ON CONFLICT (cod_banco) DO NOTHING;

-- Programas Sociais (caso não existam do schema)
INSERT INTO programa_social (nome_programa, descricao, valor_base, renda_max_elegib, orgao_resp, ativo)
VALUES
    ('Auxílio Brasil',      'Programa de transferência de renda',          600.00, 218.00, 'Ministério do Desenvolvimento Social', true),
    ('Bolsa Educação',      'Auxílio para famílias com crianças na escola',200.00, 500.00, 'Ministério da Educação',               true),
    ('Auxílio Emergencial', 'Apoio temporário em situações de crise',      400.00, NULL,   'Ministério da Economia',               true),
    ('BPC - LOAS',          'Benefício de Prestação Continuada',           1412.00,NULL,   'INSS',                                 true),
    ('Tarifa Social Energia','Desconto na conta de energia elétrica',       65.00, 218.00, 'ANEEL',                                true)
ON CONFLICT (nome_programa) DO NOTHING;

-- Cidadãos de teste
INSERT INTO cidadao (cpf, nome, data_nascimento, renda_familiar, status)
VALUES
    ('12345678901', 'João da Silva',       '1985-03-10', 900.00,  'ATIVO'),
    ('98765432100', 'Maria Oliveira',      '1992-07-22', 1200.00, 'ATIVO'),
    ('11122233344', 'Pedro Santos',        '1978-11-05', 450.00,  'ATIVO'),
    ('55566677788', 'Ana Costa',           '2001-01-30', 0.00,    'ATIVO'),
    ('99988877766', 'Carlos Ferreira',     '1960-09-14', 2000.00, 'BLOQUEADO')
ON CONFLICT (cpf) DO NOTHING;

-- Contas bancárias de teste
INSERT INTO conta_bancaria (agencia, conta, cpf_titular, cod_banco, tipo_conta, saldo, data_abertura, status)
VALUES
    ('0001', '123456-7',  '12345678901', '001', 'CORRENTE', 350.00,  '2019-05-10', true),
    ('1234', '987654-3',  '98765432100', '104', 'POUPANCA', 800.00,  '2020-08-20', true),
    ('0072', '456789-0',  '11122233344', '260', 'DIGITAL',  120.50,  '2022-01-15', true)
ON CONFLICT DO NOTHING;

-- Benefícios de teste
INSERT INTO beneficio (cpf_cidadao, id_programa, valor_calculado, data_concessao, data_validade, status, motivo_concessao)
VALUES
    ('12345678901', 1, 600.00, '2024-01-01', '2024-12-31', 'ATIVO',    'Renda familiar abaixo do limite'),
    ('98765432100', 2, 200.00, '2024-03-01', '2025-02-28', 'ATIVO',    'Filho em idade escolar'),
    ('11122233344', 1, 600.00, '2024-01-01', '2024-06-30', 'SUSPENSO', 'Aguardando atualização cadastral'),
    ('55566677788', 3, 400.00, '2024-06-01', NULL,         'ATIVO',    'Situação de vulnerabilidade')
ON CONFLICT DO NOTHING;