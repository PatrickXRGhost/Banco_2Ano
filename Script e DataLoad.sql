-- Drops
DROP TABLE IF EXISTS motorista CASCADE;
DROP TABLE IF EXISTS manutencao CASCADE;
DROP TABLE IF EXISTS alerta CASCADE;
DROP TABLE IF EXISTS caminhao CASCADE;
DROP TABLE IF EXISTS arduino CASCADE;
DROP TABLE IF EXISTS servico CASCADE;
DROP TABLE IF EXISTS empresa CASCADE;
DROP TABLE IF EXISTS rota_caminhao CASCADE;
DROP TABLE IF EXISTS caminhao_manutencao CASCADE;
DROP TABLE IF EXISTS motorista_empresa CASCADE;

-- Script
CREATE TABLE motorista 
( 
 id SERIAL PRIMARY KEY,
 id_empresa INT,
 cod_empresa VARCHAR(15)
); 

CREATE TABLE manutencao 
( 
 id SERIAL PRIMARY KEY,
 status VARCHAR(15) DEFAULT 'PENDENTE',
 titulo VARCHAR(250), 
 info TEXT,
 id_caminhao INT
); 

CREATE TABLE alerta 
( 
 id SERIAL PRIMARY KEY,
 status VARCHAR(15) DEFAULT 'PENDENTE',
 categoria VARCHAR(25),
 titulo VARCHAR(50), 
 descricao TEXT,
 id_caminhao INT
); 

CREATE TABLE caminhao 
( 
 id SERIAL PRIMARY KEY,  
 status VARCHAR(50) DEFAULT 'PENDENTE',  
 capacidade INT,  
 placa VARCHAR(30) UNIQUE,  
 modelo VARCHAR(50),  
 id_motorista INT UNIQUE
); 

CREATE TABLE arduino 
( 
 id SERIAL PRIMARY KEY,
 id_caminhao INT,
 velocidade_veiculo NUMERIC(11, 2),
 rotacoes_minuto_motor INT,
 carga_motor NUMERIC(11, 2),
 tempo_motor_ligado INT,
 posicao_acelerador NUMERIC(11, 2),
 consumo_combustivel NUMERIC(11, 2),
 nivel_combustivel NUMERIC(11, 2),
 status_sistema_combustivel VARCHAR(20) DEFAULT 'UNKNOWN',
 quilometragem NUMERIC(11, 2),
 temperatura_liquido_arrefecimento NUMERIC(11, 2),
 temperatura_ar_admissao NUMERIC(11, 2),
 pressao_oleo_motor NUMERIC(11, 2),
 pressao_coletor_admissao NUMERIC(11, 2),
 leitura_sensores_oxigenio NUMERIC(11, 2),
 leitura_sensor_oxigenio_2 NUMERIC(11, 2),
 tensao_bateria NUMERIC(11, 2),
 codigos_diagnostico_ativos VARCHAR(20),
 codigos_diagnostico_pendentes VARCHAR(20), 
 data_hora_leitura TIMESTAMP
);

CREATE TABLE servico 
( 
 id SERIAL PRIMARY KEY,  
 desc_servico TEXT,
 custo INT,  
 data_inicio DATE,
 data_conclusao DATE,
 id_manutencao INT
); 

CREATE TABLE empresa 
( 
 id SERIAL PRIMARY KEY,  
 nome VARCHAR(100),
 cnpj VARCHAR(15) UNIQUE,  
 email VARCHAR(200),
 senha VARCHAR(150),
 tipo_empresa VARCHAR(100),
 area_atuacao VARCHAR(100),
 razao_social VARCHAR(100),
 CNAE VARCHAR(20),
 telefone VARCHAR(17),
 endereco VARCHAR(300),
 tamanho_empresa INT,  
 tamanho_frota INT,
 cod_empresa VARCHAR(15)
); 

CREATE TABLE rota_caminhao (
 id SERIAL PRIMARY KEY,
 id_caminhao INT,
 status VARCHAR(25),
 distancia NUMERIC(10, 2),
 destino_inicial TEXT,
 destino_final TEXT,
 data_chegada_prevista DATE
);

CREATE TABLE caminhao_manutencao 
( 
 id SERIAL PRIMARY KEY,  
 id_caminhao INT,  
 id_manutencao INT  
); 

CREATE TABLE motorista_empresa 
( 
 id SERIAL PRIMARY KEY,  
 id_motorista INT,  
 id_empresa INT  
); 

ALTER TABLE caminhao ADD CONSTRAINT fk_caminhao_motorista FOREIGN KEY (id_motorista) REFERENCES motorista(id);
ALTER TABLE motorista ADD CONSTRAINT fk_motorista_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id); 
ALTER TABLE caminhao_manutencao ADD CONSTRAINT fk_caminhao_manutencao_caminhao FOREIGN KEY (id_caminhao) REFERENCES caminhao(id);
ALTER TABLE caminhao_manutencao ADD CONSTRAINT fk_caminhao_manutencao_manutencao FOREIGN KEY (id_manutencao) REFERENCES manutencao(id);
ALTER TABLE motorista_empresa ADD CONSTRAINT fk_motorista_empresa_motorista FOREIGN KEY (id_motorista) REFERENCES motorista(id); 
ALTER TABLE motorista_empresa ADD CONSTRAINT fk_motorista_empresa_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id); 
ALTER TABLE manutencao ADD CONSTRAINT fk_manutencao_caminhao FOREIGN KEY (id_caminhao) REFERENCES caminhao(id); 
ALTER TABLE alerta ADD CONSTRAINT fk_alerta_caminhao FOREIGN KEY (id_caminhao) REFERENCES caminhao(id);
ALTER TABLE arduino ADD CONSTRAINT fk_arduino_caminhao FOREIGN KEY (id_caminhao) REFERENCES caminhao(id); 
ALTER TABLE servico ADD CONSTRAINT fk_servico_manutencao FOREIGN KEY (id_manutencao) REFERENCES manutencao(id);
ALTER TABLE rota_caminhao ADD CONSTRAINT fk_rota_caminhao FOREIGN KEY (id_caminhao) REFERENCES caminhao(id);

SELECT * FROM motorista ORDER BY 1;
SELECT * FROM manutencao ORDER BY 1;
SELECT * FROM alerta ORDER BY 1;
SELECT * FROM caminhao ORDER BY 1;
SELECT * FROM arduino ORDER BY 1;
SELECT * FROM servico ORDER BY 1;
SELECT * FROM empresa ORDER BY 1;
SELECT * FROM rota_caminhao ORDER BY 1;
SELECT * FROM caminhao_manutencao ORDER BY 1;
SELECT * FROM motorista_empresa ORDER BY 1;
SELECT * FROM maps ORDER BY 1;

-- DataLoad
-- EMPRESAS
INSERT INTO empresa (id, nome, cnpj, email, senha, tipo_empresa, area_atuacao, razao_social, cnae, telefone, endereco, tamanho_empresa, tamanho_frota, cod_empresa) VALUES
(1, 'TransLogix', '12345678000101', 'contato@translogix.com.br', 'senha123', 'Transportadora', 'Logística', 'TransLogix Ltda', '4930-2/01', '(11) 99999-0001', 'Rua Alpha, 100 - SP', 200, 50, 'EMP001'),
(2, 'CargaMax', '22345678000102', 'suporte@cargamax.com.br', 'senha123', 'Transportadora', 'Distribuição', 'CargaMax SA', '4930-2/01', '(11) 99999-0002', 'Rua Beta, 200 - RJ', 150, 30, 'EMP002'),
(3, 'FastTruck', '32345678000103', 'admin@fasttruck.com', 'senha123', 'Frete Rápido', 'Transporte', 'FastTruck ME', '4930-2/01', '(11) 99999-0003', 'Rua Gama, 300 - MG', 80, 20, 'EMP003'),
(4, 'LogiPro', '42345678000104', 'atendimento@logipro.com', 'senha123', 'Logística', 'Logística', 'LogiPro Eireli', '4930-2/01', '(11) 99999-0004', 'Av. Central, 400 - RS', 300, 60, 'EMP004'),
(5, 'CargaSul', '52345678000105', 'contato@cargasul.com', 'senha123', 'Transportadora', 'Sul do Brasil', 'CargaSul Ltda', '4930-2/01', '(51) 99999-0005', 'Rua Sul, 500 - SC', 120, 25, 'EMP005'),
(6, 'NorteTrans', '62345678000106', 'norte@nortetrans.com', 'senha123', 'Transportadora', 'Norte do Brasil', 'NorteTrans S.A.', '4930-2/01', '(92) 99999-0006', 'Rua Norte, 600 - AM', 90, 18, 'EMP006'),
(7, 'CentroMove', '72345678000107', 'contato@centromove.com', 'senha123', 'Transportadora', 'Centro-Oeste', 'CentroMove Ltda', '4930-2/01', '(62) 99999-0007', 'Rua Centro, 700 - GO', 130, 28, 'EMP007'),
(8, 'MegaLog', '82345678000108', 'admin@megalog.com', 'senha123', 'Logística', 'Todo Brasil', 'MegaLog LTDA', '4930-2/01', '(21) 99999-0008', 'Rua Mega, 800 - RJ', 500, 80, 'EMP008'),
(9, 'BRTransport', '92345678000109', 'suporte@brtransport.com', 'senha123', 'Frete Nacional', 'Transporte', 'BRTransport Ltda', '4930-2/01', '(31) 99999-0009', 'Av. Brasil, 900 - MG', 250, 45, 'EMP009'),
(10, 'FlexCarga', '10345678000110', 'contato@flexcarga.com', 'senha123', 'Transportadora', 'Logística flexível', 'FlexCarga Eireli', '4930-2/01', '(41) 99999-0010', 'Rua Flex, 1000 - PR', 110, 22, 'EMP010');

-- MOTORISTAS
INSERT INTO motorista (id, id_empresa, cod_empresa) VALUES
(1, 1, 'EMP001'), (2, 2, 'EMP002'), (3, 3, 'EMP003'), (4, 4, 'EMP004'), (5, 5, 'EMP005'),
(6, 6, 'EMP006'), (7, 7, 'EMP007'), (8, 8, 'EMP008'), (9, 9, 'EMP009'), (10, 10, 'EMP010');

-- CAMINHÕES
INSERT INTO caminhao (id, status, capacidade, placa, modelo, id_motorista) VALUES
(1, 'ATIVO', 20000, 'ABC1D23', 'Volvo FH 540', 1),
(2, 'ATIVO', 18000, 'BCD2E34', 'Scania R450', 2),
(3, 'ATIVO', 16000, 'CDE3F45', 'Mercedes Actros', 3),
(4, 'PENDENTE', 14000, 'DEF4G56', 'DAF XF', 4),
(5, 'PENDENTE', 22000, 'EFG5H67', 'Iveco Hi-Way', 5),
(6, 'ATIVO', 15000, 'FGH6I78', 'MAN TGX', 6),
(7, 'ATIVO', 17000, 'GHI7J89', 'VW Constellation', 7),
(8, 'PENDENTE', 13000, 'HIJ8K90', 'Ford Cargo', 8),
(9, 'ATIVO', 19000, 'IJK9L01', 'Volvo VM', 9),
(10, 'ATIVO', 21000, 'JKL0M12', 'Scania R620', 10);

-- MOTORISTA_EMPRESA
INSERT INTO motorista_empresa (id, id_motorista, id_empresa) VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5),
(6, 6, 6), (7, 7, 7), (8, 8, 8), (9, 9, 9), (10, 10, 10);

-- MANUTENÇÕES
INSERT INTO manutencao (id, status, titulo, info, id_caminhao) VALUES
(1, TRUE, 'Troca de óleo', 'Óleo e filtro trocados', 1),
(2, TRUE, 'Revisão freios', 'Pastilhas substituídas', 2),
(3, FALSE, 'Alinhamento', 'Verificação de eixo traseiro', 3),
(4, TRUE, 'Troca de pneus', 'Pneus dianteiros novos', 4),
(5, TRUE, 'Sistema elétrico', 'Bateria substituída', 5),
(6, FALSE, 'Troca de embreagem', 'Em andamento', 6),
(7, TRUE, 'Revisão geral', 'Checklist completo realizado', 7),
(8, FALSE, 'Troca de farol', 'Farol em falta', 8),
(9, TRUE, 'Troca de fluído', 'Fluído de freio novo', 9),
(10, TRUE, 'Inspeção suspensão', 'Tudo ok', 10);

-- CAMINHAO_MANUTENCAO
INSERT INTO caminhao_manutencao (id, id_caminhao, id_manutencao) VALUES
(1,1,1), (2,2,2), (3,3,3), (4,4,4), (5,5,5),
(6,6,6), (7,7,7), (8,8,8), (9,9,9), (10,10,10);

-- SERVIÇOS
INSERT INTO servico (id, desc_servico, custo, data_inicio, data_conclusao, id_manutencao) VALUES
(1, 'Troca completa de óleo e filtro', 350, '2025-10-01', '2025-10-02', 1),
(2, 'Substituição de pastilhas de freio', 420, '2025-09-20', '2025-09-21', 2),
(3, 'Verificação e alinhamento traseiro', 300, '2025-10-03', '2025-10-03', 3),
(4, 'Pneus novos instalados', 1200, '2025-09-15', '2025-09-16', 4),
(5, 'Instalação de nova bateria', 500, '2025-10-05', '2025-10-05', 5),
(6, 'Troca de embreagem', 800, '2025-10-10', NULL, 6),
(7, 'Revisão completa realizada', 950, '2025-09-01', '2025-09-03', 7),
(8, 'Aguardando farol em estoque', 150, '2025-10-09', NULL, 8),
(9, 'Substituição de fluído de freio', 220, '2025-10-04', '2025-10-04', 9),
(10, 'Inspeção e ajuste da suspensão', 600, '2025-09-28', '2025-09-28', 10);

-- ALERTAS
INSERT INTO alerta (id, status, categoria, titulo, descricao, id_caminhao) VALUES
(1, TRUE, 'Motor', 'Superaquecimento', 'Temperatura acima do limite', 1),
(2, FALSE, 'Freio', 'Desgaste de pastilha', 'Pastilhas devem ser trocadas', 2),
(3, TRUE, 'Óleo', 'Nível baixo', 'Verificar nível do óleo', 3),
(4, TRUE, 'Pneu', 'Pressão baixa', 'Calibrar imediatamente', 4),
(5, FALSE, 'Bateria', 'Carga fraca', 'Precisa de recarga', 5),
(6, TRUE, 'Motor', 'Falha de ignição', 'Verificar velas', 6),
(7, TRUE, 'Freio', 'ABS inoperante', 'Sistema ABS não está funcionando', 7),
(8, TRUE, 'Elétrico', 'Falha geral', 'Pane elétrica detectada', 8),
(9, FALSE, 'Sensor', 'Sensor inativo', 'Sensor de temperatura não responde', 9),
(10, TRUE, 'Combustível', 'Consumo anormal', 'Verificar sistema de injeção', 10);

-- ROTA CAMINHÃO
INSERT INTO rota_caminhao (id, id_caminhao, status, distancia, destino_inicial, destino_final, data_chegada_prevista) VALUES
(1, 1, 'EM ROTA', 800.5, 'São Paulo', 'Curitiba', '2025-10-18'),
(2, 2, 'EM ROTA', 450.0, 'Rio de Janeiro', 'Belo Horizonte', '2025-10-19'),
(3, 3, 'FINALIZADA', 1200.0, 'Brasília', 'Goiânia', '2025-10-17'),
(4, 4, 'EM ROTA', 900.3, 'Fortaleza', 'Recife', '2025-10-21'),
(5, 5, 'PENDENTE', 700.1, 'Porto Alegre', 'Florianópolis', '2025-10-22'),
(6, 6, 'EM ROTA', 550.0, 'Belém', 'São Luís', '2025-10-23'),
(7, 7, 'FINALIZADA', 300.0, 'Campo Grande', 'Cuiabá', '2025-10-16'),
(8, 8, 'EM ROTA', 670.0, 'Vitória', 'Salvador', '2025-10-20'),
(9, 9, 'PENDENTE', 1000.0, 'Manaus', 'Boa Vista', '2025-10-25'),
(10, 10, 'FINALIZADA', 820.0, 'João Pessoa', 'Natal', '2025-10-15');

INSERT INTO arduino (
  id, id_caminhao, velocidade_veiculo, rotacoes_minuto_motor, carga_motor,
  tempo_motor_ligado, posicao_acelerador, consumo_combustivel, nivel_combustivel,
  status_sistema_combustivel, quilometragem, temperatura_liquido_arrefecimento,
  temperatura_ar_admissao, pressao_oleo_motor, pressao_coletor_admissao,
  leitura_sensores_oxigenio, leitura_sensor_oxigenio_2, tensao_bateria,
  codigos_diagnostico_ativos, codigos_diagnostico_pendentes, data_hora_leitura
) VALUES
(1, 1, 82.5, 2100, 65.3, 3600, 35.2, 12.3, 45.8, 'OK', 152000.5, 95.2, 35.5, 3.5, 0.98, 0.02, 0.03, 13.5, 'P0135', 'P0300', NOW()),
(2, 2, 60.0, 1800, 55.0, 2900, 30.0, 11.0, 50.0, 'OK', 143000.0, 92.0, 30.0, 3.0, 1.00, 0.02, 0.04, 13.2, 'P0101', '', NOW()),
(3, 3, 70.5, 2000, 62.5, 3100, 33.0, 12.0, 48.0, 'OK', 149500.5, 94.0, 32.5, 3.3, 1.05, 0.01, 0.03, 13.4, '', '', NOW()),
(4, 4, 85.0, 2200, 64.0, 3800, 36.0, 13.2, 46.0, 'OK', 158000.2, 97.0, 36.0, 3.8, 0.96, 0.02, 0.02, 13.8, 'P0401', '', NOW()),
(5, 5, 50.0, 1500, 50.0, 2700, 28.0, 10.5, 51.0, 'OK', 132000.3, 88.0, 28.5, 2.8, 1.10, 0.03, 0.05, 12.9, '', 'P0455', NOW()),
(6, 6, 95.5, 2300, 66.0, 4000, 38.0, 14.0, 43.0, 'OK', 165000.9, 99.0, 38.0, 4.0, 0.90, 0.02, 0.04, 13.9, 'P0200', '', NOW()),
(7, 7, 75.0, 1900, 58.0, 2950, 32.0, 11.8, 49.0, 'OK', 140000.0, 93.0, 31.0, 3.2, 1.02, 0.02, 0.03, 13.3, '', '', NOW()),
(8, 8, 68.0, 1850, 57.0, 2850, 31.0, 11.5, 47.5, 'OK', 138500.7, 91.5, 29.5, 3.1, 1.03, 0.02, 0.03, 13.1, '', '', NOW()),
(9, 9, 88.5, 2400, 68.0, 4200, 40.0, 15.0, 42.0, 'OK', 170000.4, 101.0, 39.5, 4.5, 0.85, 0.01, 0.02, 14.0, 'P0420', '', NOW()),
(10, 10, 72.5, 2050, 61.0, 3250, 34.0, 12.5, 44.0, 'OK', 150000.8, 96.0, 34.5, 3.6, 0.99, 0.02, 0.03, 13.6, '', '', NOW());

-- Tabela de sessão do usuario do app
CREATE TABLE sessao(
	id SERIAL PRIMARY KEY,
	id_usuario INT NOT NULL,
	data_hora TIMESTAMP NOT NULL DEFAULT NOW(),
	tipo VARCHAR(50) NOT NULL DEFAULT 'entrada'
);

SELECT * FROM sessao;

CREATE TABLE maps(
	id SERIAL PRIMARY KEY,
	latitude NUMERIC(9, 6),
	longitude NUMERIC(9, 6),
	captura_localizacao_ml BIGINT
)

SELECT * FROM maps;

-- Tabelas para notificação
DROP TABLE IF EXISTS fcm_tokens CASCADE;
DROP TABLE IF EXISTS historico_notificacoes CASCADE;

CREATE TABLE fcm_tokens (
    id SERIAL PRIMARY KEY, 
    id_usuario INT NOT NULL,
	id_caminhao INT,
    fcm_token VARCHAR(255) NOT NULL, 
    tipo_dispositivo VARCHAR(50),
    ativo BOOLEAN DEFAULT TRUE, 
    criado_em TIMESTAMP NOT NULL,
    atualizado_em TIMESTAMP NOT NULL, 
    CONSTRAINT fk_id_usuario FOREIGN KEY (id_usuario) REFERENCES motorista(id),
	CONSTRAINT fk_id_caminhao FOREIGN KEY (id_caminhao) REFERENCES caminhao(id)
);

-- Índices para melhor performance
-- Na tabela fcm_tokens
CREATE UNIQUE INDEX ux_fcm_id_usuario_fcm_token ON fcm_tokens(id_usuario, fcm_token);
CREATE INDEX idx_fcm_id_usuario ON fcm_tokens(id_usuario);
CREATE INDEX idx_fcm_id_caminhao ON fcm_tokens(id_caminhao);
CREATE INDEX idx_fcm_ativo ON fcm_tokens(ativo);

CREATE TABLE historico_notificacoes (
    id SERIAL PRIMARY KEY, 
    id_usuario_destino INT NOT NULL, 
    titulo VARCHAR(255) NOT NULL,
    corpo TEXT NOT NULL, 
    dados_payload JSONB, 
    status VARCHAR(50) NOT NULL DEFAULT 'ENVIADA', 
    enviada_em TIMESTAMP NOT NULL, 
    id_resposta_fcm VARCHAR(255), 
	messagem_de_erro TEXT,
    CONSTRAINT fk_usuario_destino FOREIGN KEY (id_usuario_destino) REFERENCES motorista(id)
);

-- Índices para consultas e relatórios
-- Para a tabela historico_notificacoes
CREATE INDEX idx_notification_id_usuario_destino ON historico_notificacoes(id_usuario_destino);
CREATE INDEX idx_notification_status ON historico_notificacoes(status);
CREATE INDEX idx_notification_enviada_em ON historico_notificacoes(enviada_em);

SELECT * FROM fcm_tokens;
SELECT * FROM historico_notificacoes;