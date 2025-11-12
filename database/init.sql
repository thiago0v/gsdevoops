-- Script de inicialização simplificado para Docker
-- Este script é executado automaticamente quando o container PostgreSQL é criado

-- Criar tabelas
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

-- Inserir dados iniciais
INSERT INTO filial (nome, cidade, estado, endereco, capacidade_patio) VALUES
('Mottu São Paulo - Centro', 'São Paulo', 'SP', 'Av. Paulista, 1000', 150),
('Mottu Rio de Janeiro - Zona Sul', 'Rio de Janeiro', 'RJ', 'Av. Atlântica, 500', 120);

INSERT INTO usuario (nome, email, senha, role, filial_id, ativo) VALUES
('Administrador Sistema', 'admin@mottu.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN', NULL, TRUE),
('João Silva', 'operador.sp@mottu.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'OPERADOR', 1, TRUE);

INSERT INTO moto (placa, modelo, ano, filial_id, status, posicao_x, posicao_y) VALUES
('ABC1D23', 'Honda CG 160', 2023, 1, 'DISPONIVEL', 5, 3),
('XYZ4E56', 'Yamaha Factor 150', 2022, 1, 'EM_USO', 8, 2);

INSERT INTO alerta (moto_id, tipo, mensagem, resolvido) VALUES
(2, 'SEM_SINAL', 'Moto sem enviar dados há mais de 30 minutos', FALSE);
