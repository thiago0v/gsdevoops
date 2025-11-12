-- ============================================================================
-- Script DDL - MottuVision Database
-- Banco de Dados: PostgreSQL 16
-- Descrição: Schema completo para o sistema de gestão de pátios da Mottu
-- ============================================================================

-- Criação do banco de dados (executar como superuser)
-- CREATE DATABASE mottuvision WITH ENCODING 'UTF8';

-- Conectar ao banco mottuvision
\c mottuvision;

-- ============================================================================
-- TABELA: FILIAL
-- Descrição: Armazena informações das filiais da Mottu
-- ============================================================================
CREATE TABLE IF NOT EXISTS filial (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    endereco VARCHAR(255),
    capacidade_patio INTEGER DEFAULT 100,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE filial IS 'Armazena as filiais da Mottu';
COMMENT ON COLUMN filial.id IS 'Identificador único da filial';
COMMENT ON COLUMN filial.nome IS 'Nome da filial';
COMMENT ON COLUMN filial.cidade IS 'Cidade onde a filial está localizada';
COMMENT ON COLUMN filial.estado IS 'Sigla do estado (UF)';
COMMENT ON COLUMN filial.endereco IS 'Endereço completo da filial';
COMMENT ON COLUMN filial.capacidade_patio IS 'Capacidade máxima de motos no pátio';

-- ============================================================================
-- TABELA: USUARIO
-- Descrição: Armazena os usuários do sistema (operadores e administradores)
-- ============================================================================
CREATE TABLE IF NOT EXISTS usuario (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'OPERADOR',
    filial_id BIGINT,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_filial FOREIGN KEY (filial_id) REFERENCES filial(id) ON DELETE SET NULL
);

COMMENT ON TABLE usuario IS 'Usuários do sistema (operadores e administradores)';
COMMENT ON COLUMN usuario.id IS 'Identificador único do usuário';
COMMENT ON COLUMN usuario.nome IS 'Nome completo do usuário';
COMMENT ON COLUMN usuario.email IS 'Email corporativo (usado para login)';
COMMENT ON COLUMN usuario.senha IS 'Senha criptografada (BCrypt)';
COMMENT ON COLUMN usuario.role IS 'Papel do usuário: ADMIN ou OPERADOR';
COMMENT ON COLUMN usuario.filial_id IS 'Filial à qual o usuário está vinculado';
COMMENT ON COLUMN usuario.ativo IS 'Indica se o usuário está ativo no sistema';

-- Índice para melhorar performance de login
CREATE INDEX idx_usuario_email ON usuario(email);

-- ============================================================================
-- TABELA: MOTO
-- Descrição: Armazena informações das motos gerenciadas pela Mottu
-- ============================================================================
CREATE TABLE IF NOT EXISTS moto (
    id BIGSERIAL PRIMARY KEY,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(50) NOT NULL,
    ano INTEGER,
    filial_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL',
    posicao_x INTEGER,
    posicao_y INTEGER,
    ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_moto_filial FOREIGN KEY (filial_id) REFERENCES filial(id) ON DELETE CASCADE
);

COMMENT ON TABLE moto IS 'Motos gerenciadas pela Mottu';
COMMENT ON COLUMN moto.id IS 'Identificador único da moto';
COMMENT ON COLUMN moto.placa IS 'Placa da moto (formato brasileiro)';
COMMENT ON COLUMN moto.modelo IS 'Modelo da moto';
COMMENT ON COLUMN moto.ano IS 'Ano de fabricação';
COMMENT ON COLUMN moto.filial_id IS 'Filial onde a moto está localizada';
COMMENT ON COLUMN moto.status IS 'Status atual: DISPONIVEL, EM_USO, MANUTENCAO, ALERTA';
COMMENT ON COLUMN moto.posicao_x IS 'Posição X no mapa do pátio';
COMMENT ON COLUMN moto.posicao_y IS 'Posição Y no mapa do pátio';
COMMENT ON COLUMN moto.ultima_atualizacao IS 'Última vez que a moto enviou dados';

-- Índices para melhorar performance
CREATE INDEX idx_moto_filial ON moto(filial_id);
CREATE INDEX idx_moto_status ON moto(status);
CREATE INDEX idx_moto_placa ON moto(placa);

-- ============================================================================
-- TABELA: ALERTA
-- Descrição: Armazena alertas gerados automaticamente pelo sistema
-- ============================================================================
CREATE TABLE IF NOT EXISTS alerta (
    id BIGSERIAL PRIMARY KEY,
    moto_id BIGINT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    mensagem TEXT NOT NULL,
    resolvido BOOLEAN DEFAULT FALSE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_resolucao TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alerta_moto FOREIGN KEY (moto_id) REFERENCES moto(id) ON DELETE CASCADE
);

COMMENT ON TABLE alerta IS 'Alertas gerados automaticamente pelo sistema';
COMMENT ON COLUMN alerta.id IS 'Identificador único do alerta';
COMMENT ON COLUMN alerta.moto_id IS 'Moto relacionada ao alerta';
COMMENT ON COLUMN alerta.tipo IS 'Tipo do alerta: SEM_SINAL, BATERIA_BAIXA, MANUTENCAO_NECESSARIA';
COMMENT ON COLUMN alerta.mensagem IS 'Descrição detalhada do alerta';
COMMENT ON COLUMN alerta.resolvido IS 'Indica se o alerta foi resolvido';
COMMENT ON COLUMN alerta.data_criacao IS 'Data e hora de criação do alerta';
COMMENT ON COLUMN alerta.data_resolucao IS 'Data e hora de resolução do alerta';

-- Índices para melhorar performance
CREATE INDEX idx_alerta_moto ON alerta(moto_id);
CREATE INDEX idx_alerta_resolvido ON alerta(resolvido);
CREATE INDEX idx_alerta_data_criacao ON alerta(data_criacao DESC);

-- ============================================================================
-- INSERÇÃO DE DADOS INICIAIS
-- ============================================================================

-- Inserir filiais
INSERT INTO filial (nome, cidade, estado, endereco, capacidade_patio) VALUES
('Mottu São Paulo - Centro', 'São Paulo', 'SP', 'Av. Paulista, 1000', 150),
('Mottu Rio de Janeiro - Zona Sul', 'Rio de Janeiro', 'RJ', 'Av. Atlântica, 500', 120),
('Mottu Belo Horizonte', 'Belo Horizonte', 'MG', 'Av. Afonso Pena, 750', 100);

-- Inserir usuários (senha: 123456 - BCrypt hash)
INSERT INTO usuario (nome, email, senha, role, filial_id, ativo) VALUES
('Administrador Sistema', 'admin@mottu.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN', NULL, TRUE),
('João Silva', 'operador.sp@mottu.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'OPERADOR', 1, TRUE),
('Maria Santos', 'operador.rj@mottu.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'OPERADOR', 2, TRUE);

-- Inserir motos
INSERT INTO moto (placa, modelo, ano, filial_id, status, posicao_x, posicao_y, ultima_atualizacao) VALUES
('ABC1D23', 'Honda CG 160', 2023, 1, 'DISPONIVEL', 5, 3, CURRENT_TIMESTAMP),
('XYZ4E56', 'Yamaha Factor 150', 2022, 1, 'EM_USO', 8, 2, CURRENT_TIMESTAMP),
('DEF7G89', 'Honda CG 160', 2023, 2, 'DISPONIVEL', 3, 4, CURRENT_TIMESTAMP),
('GHI0J12', 'Yamaha Factor 150', 2021, 2, 'MANUTENCAO', 10, 5, CURRENT_TIMESTAMP - INTERVAL '2 hours'),
('JKL3M45', 'Honda CG 160', 2024, 1, 'ALERTA', 2, 7, CURRENT_TIMESTAMP - INTERVAL '30 minutes');

-- Inserir alertas
INSERT INTO alerta (moto_id, tipo, mensagem, resolvido, data_criacao) VALUES
(4, 'MANUTENCAO_NECESSARIA', 'Moto com 10.000 km rodados - manutenção preventiva necessária', FALSE, CURRENT_TIMESTAMP - INTERVAL '1 day'),
(5, 'SEM_SINAL', 'Moto sem enviar dados há mais de 30 minutos', FALSE, CURRENT_TIMESTAMP - INTERVAL '30 minutes');

-- ============================================================================
-- TRIGGERS PARA ATUALIZAÇÃO AUTOMÁTICA DE updated_at
-- ============================================================================

-- Função genérica para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para tabela filial
CREATE TRIGGER update_filial_updated_at
    BEFORE UPDATE ON filial
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para tabela usuario
CREATE TRIGGER update_usuario_updated_at
    BEFORE UPDATE ON usuario
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para tabela moto
CREATE TRIGGER update_moto_updated_at
    BEFORE UPDATE ON moto
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para tabela alerta
CREATE TRIGGER update_alerta_updated_at
    BEFORE UPDATE ON alerta
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- VIEWS ÚTEIS
-- ============================================================================

-- View: Motos com alertas ativos
CREATE OR REPLACE VIEW motos_com_alertas AS
SELECT 
    m.id,
    m.placa,
    m.modelo,
    f.nome AS filial_nome,
    m.status,
    COUNT(a.id) AS total_alertas
FROM moto m
INNER JOIN filial f ON m.filial_id = f.id
LEFT JOIN alerta a ON m.id = a.moto_id AND a.resolvido = FALSE
GROUP BY m.id, m.placa, m.modelo, f.nome, m.status
HAVING COUNT(a.id) > 0;

-- View: Dashboard por filial
CREATE OR REPLACE VIEW dashboard_filial AS
SELECT 
    f.id AS filial_id,
    f.nome AS filial_nome,
    COUNT(m.id) AS total_motos,
    COUNT(CASE WHEN m.status = 'DISPONIVEL' THEN 1 END) AS motos_disponiveis,
    COUNT(CASE WHEN m.status = 'EM_USO' THEN 1 END) AS motos_em_uso,
    COUNT(CASE WHEN m.status = 'MANUTENCAO' THEN 1 END) AS motos_manutencao,
    COUNT(CASE WHEN m.status = 'ALERTA' THEN 1 END) AS motos_alerta
FROM filial f
LEFT JOIN moto m ON f.id = m.filial_id
GROUP BY f.id, f.nome;

-- ============================================================================
-- PERMISSÕES (Ajustar conforme necessário)
-- ============================================================================

-- Criar usuário para a aplicação (opcional)
-- CREATE USER mottu_app WITH PASSWORD 'senha_segura_aqui';
-- GRANT CONNECT ON DATABASE mottuvision TO mottu_app;
-- GRANT USAGE ON SCHEMA public TO mottu_app;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO mottu_app;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO mottu_app;

-- ============================================================================
-- FIM DO SCRIPT
-- ============================================================================
