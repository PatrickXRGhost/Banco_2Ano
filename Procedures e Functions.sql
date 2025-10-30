-- ===================================================
-- PROCEDURE: Inserção de Motorista
-- ===================================================
CREATE OR REPLACE PROCEDURE insert_motorista(
    id_emp INT, 
    cod_emp VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
	id_mot INTEGER;
BEGIN
    IF LENGTH(cod_emp) = 6 THEN
        IF EXISTS (SELECT 1 FROM empresa WHERE id = id_emp AND cod_empresa = cod_emp) THEN
			SELECT COALESCE(MAX(id), 0) + 1 INTO id_mot FROM motorista;
		
            INSERT INTO motorista (id, id_empresa, cod_empresa)
            VALUES (id_mot, id_emp, cod_emp);
        ELSE
            RAISE EXCEPTION '[ERROR] A empresa com esse ID e CÓDIGO não existe!';
        END IF;
    ELSE
        RAISE EXCEPTION '[ERROR] O código de empresa precisa ter 6 caracteres!';
    END IF;
END;
$$;

-- ===================================================
-- PROCEDURE: Inserção de Manutenção
-- ===================================================
CREATE OR REPLACE PROCEDURE insert_manutencao(
    p_titulo VARCHAR,
    p_info TEXT,
    p_id_caminhao INT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM caminhao WHERE id = p_id_caminhao) THEN
        INSERT INTO manutencao (status, titulo, info, id_caminhao)
        VALUES ('PENDENTE', p_titulo, p_info, p_id_caminhao);
    ELSE
        RAISE EXCEPTION '[ERROR] Caminhão com ID % não existe!', p_id_caminhao;
    END IF;
END;
$$;

-- ===================================================
-- PROCEDURE: Inserção de Caminhão
-- ===================================================
CREATE OR REPLACE PROCEDURE insert_caminhao(cap INT, plc VARCHAR, mold VARCHAR, id_moto INT)
LANGUAGE plpgsql AS $$
DECLARE
    id_cam INT;
BEGIN
    SELECT COALESCE(MAX(id), 0) + 1 INTO id_cam FROM caminhao;

    IF LENGTH(plc) = 7 AND NOT EXISTS (SELECT 1 FROM caminhao WHERE placa = plc) THEN
        IF cap >= 3 THEN
            IF LENGTH(mold) >= 3 THEN
                IF EXISTS (SELECT 1 FROM motorista WHERE id = id_moto) THEN
                    INSERT INTO caminhao (id, capacidade, placa, modelo, id_motorista)
                    VALUES (id_cam, cap, plc, mold, id_moto);
                ELSE
                    RAISE EXCEPTION '[ERROR] Motorista com ID % não existe!', id_moto;
                END IF;
            ELSE
                RAISE EXCEPTION '[ERROR] O modelo deve ter no mínimo 3 caracteres!';
            END IF;
        ELSE
            RAISE EXCEPTION '[ERROR] Capacidade mínima do caminhão é de 3 toneladas!';
        END IF;
    ELSE
        RAISE EXCEPTION '[ERROR] A placa deve ter 7 caracteres e ser única!';
    END IF;
END;
$$;

-- ===================================================
-- PROCEDURE: Inserção de Leitura Arduino
-- ===================================================
CREATE OR REPLACE PROCEDURE insert_arduino(
    id_cam INT,
    velo_vei NUMERIC(11, 2),
    rota_min_motor INT,
    carga_mot NUMERIC(11, 2),
    tempo_mot_lig INT,
    pos_acel NUMERIC(11, 2),
    cons_comb NUMERIC(11, 2),
    nivel_comb NUMERIC(11, 2),
    status_sist_comb VARCHAR(20),
    km NUMERIC(11, 2),
    temp_liq_arref NUMERIC(11, 2),
    temp_ar_adm NUMERIC(11, 2),
    press_oleo_mot NUMERIC(11, 2),
    press_coletor_adm NUMERIC(11, 2),
    leitura_sens_ox NUMERIC(11, 2),
    leitura_sens_ox2 NUMERIC(11, 2),
    tensao_bat NUMERIC(11, 2),
    cod_diag_ativos VARCHAR(20),
    cod_diag_pendentes VARCHAR(20),
    data_leitura TIMESTAMP
)
LANGUAGE plpgsql AS $$
DECLARE
	id_ard INT;
BEGIN
	SELECT COALESCE(MAX(id), 0) + 1 INTO id_ard FROM arduino;
		
    IF NOT EXISTS (SELECT 1 FROM caminhao WHERE id = id_cam) THEN
        RAISE EXCEPTION '[ERROR] Caminhão com ID % não encontrado!', id_cam;
    END IF;

    IF velo_vei < 0 THEN
        RAISE EXCEPTION '[ERROR] Velocidade do veículo não pode ser negativa!';
    END IF;

    IF rota_min_motor < 0 THEN
        RAISE EXCEPTION '[ERROR] RPM do motor não pode ser negativo!';
    END IF;

    IF carga_mot < 0 OR carga_mot > 100 THEN
        RAISE EXCEPTION '[ERROR] Carga do motor deve estar entre 0 e 100!';
    END IF;

    IF tempo_mot_lig < 0 THEN
        RAISE EXCEPTION '[ERROR] Tempo com motor ligado não pode ser negativo!';
    END IF;

    IF pos_acel < 0 OR pos_acel > 100 THEN
        RAISE EXCEPTION '[ERROR] Posição do acelerador deve estar entre 0 e 100!';
    END IF;

    IF nivel_comb < 0 OR nivel_comb > 100 THEN
        RAISE EXCEPTION '[ERROR] Nível de combustível deve estar entre 0 e 100!';
    END IF;

    IF data_leitura > NOW() THEN
        RAISE EXCEPTION '[ERROR] Data de leitura não pode estar no futuro!';
    END IF;

    INSERT INTO arduino (
        id, id_caminhao, velocidade_veiculo, rotacoes_minuto_motor,
        carga_motor, tempo_motor_ligado, posicao_acelerador, consumo_combustivel,
        nivel_combustivel, status_sistema_combustivel, quilometragem,
        temperatura_liquido_arrefecimento, temperatura_ar_admissao,
        pressao_oleo_motor, pressao_coletor_admissao, leitura_sensores_oxigenio,
        leitura_sensor_oxigenio_2, tensao_bateria, codigos_diagnostico_ativos,
        codigos_diagnostico_pendentes, data_hora_leitura
    )
    VALUES (
        id_ard, id_cam, velo_vei, rota_min_motor, carga_mot, tempo_mot_lig,
        pos_acel, cons_comb, nivel_comb, status_sist_comb, km,
        temp_liq_arref, temp_ar_adm, press_oleo_mot, press_coletor_adm,
        leitura_sens_ox, leitura_sens_ox2, tensao_bat, cod_diag_ativos,
        cod_diag_pendentes, data_leitura
    );
END;
$$;

-- ===================================================
-- PROCEDURE: Inserção de Alerta
-- ===================================================
CREATE OR REPLACE PROCEDURE insert_alerta(
    p_status VARCHAR,
    p_categoria VARCHAR,
    p_titulo VARCHAR,
    p_descricao TEXT,
    p_id_caminhao INT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF LENGTH(p_categoria) <= 25 AND LENGTH(p_titulo) <= 50 THEN
        IF EXISTS (SELECT 1 FROM caminhao WHERE id = p_id_caminhao) THEN
            INSERT INTO alerta (status, categoria, titulo, descricao, id_caminhao)
            VALUES (p_status, p_categoria, p_titulo, p_descricao, p_id_caminhao);
        ELSE
            RAISE EXCEPTION '[ERROR] Caminhão com ID % não encontrado!', p_id_caminhao;
        END IF;
    ELSE
        RAISE EXCEPTION '[ERROR] Categoria ou Título excede o limite de caracteres!';
    END IF;
END;
$$;

-- ===================================================
-- PROCEDURE: Inserção de Serviço
-- ===================================================
CREATE OR REPLACE PROCEDURE insert_servico(
    desc_serv TEXT,
    custo_serv INT,
    dt_ini DATE,
    dt_fim DATE,
    id_manu INT
)
LANGUAGE plpgsql AS $$
DECLARE
    id_serv INT;
BEGIN
    SELECT COALESCE(MAX(id), 0) + 1 INTO id_serv FROM servico;

    IF dt_ini <= CURRENT_DATE AND dt_fim <= CURRENT_DATE THEN
        IF dt_ini < dt_fim THEN
            IF EXISTS (SELECT 1 FROM manutencao WHERE id = id_manu) THEN
                INSERT INTO servico (id, desc_servico, custo, data_inicio, data_conclusao, id_manutencao)
                VALUES (id_serv, desc_serv, custo_serv, dt_ini, dt_fim, id_manu);
            ELSE
                RAISE EXCEPTION '[ERROR] Manutenção com ID % não encontrada!', id_manu;
            END IF;
        ELSE
            RAISE EXCEPTION '[ERROR] A data de início deve ser anterior à data de conclusão!';
        END IF;
    ELSE
        RAISE EXCEPTION '[ERROR] Datas não podem estar no futuro!';
    END IF;
END;
$$;

-- ===================================================
-- PROCEDURE: Inserção de Empresa
-- ===================================================
CREATE OR REPLACE PROCEDURE insert_empresa(
    nome_emp VARCHAR,
    cnpj_emp VARCHAR,
    email_emp VARCHAR,
    senha_emp VARCHAR,
    tipo_emp VARCHAR,
    area_emp VARCHAR,
    razao_emp VARCHAR,
    cnae_emp VARCHAR,
    tel_emp VARCHAR,
    end_emp VARCHAR,
    tam_emp INT,
    tam_frota INT
)
LANGUAGE plpgsql AS $$
DECLARE
    id_emp INT;
BEGIN
    SELECT COALESCE(MAX(id), 0) + 1 INTO id_emp FROM empresa;

    IF LENGTH(cnpj_emp) = 14 THEN
        IF NOT EXISTS (SELECT 1 FROM empresa WHERE cnpj = cnpj_emp) THEN
            INSERT INTO empresa (
                id, nome, cnpj, email, senha, tipo_empresa, area_atuacao,
                razao_social, cnae, telefone, endereco, tamanho_empresa, tamanho_frota
            )
            VALUES (
                id_emp, nome_emp, cnpj_emp, email_emp, senha_emp, tipo_emp, area_emp,
                razao_emp, cnae_emp, tel_emp, end_emp, tam_emp, tam_frota
            );
        ELSE
            RAISE EXCEPTION '[ERROR] CNPJ já cadastrado!';
        END IF;
    ELSE
        RAISE EXCEPTION '[ERROR] CNPJ deve conter 14 dígitos!';
    END IF;
END;
$$;

-- ===================================================
-- PROCEDURE: Inserção de Rota de Caminhão
-- ===================================================
CREATE OR REPLACE PROCEDURE insert_rota_caminhao(
    id_cam INT,
    status_rota VARCHAR,
    distancia NUMERIC,
    dest_ini TEXT,
    dest_fim TEXT,
    data_cheg DATE
)
LANGUAGE plpgsql AS $$
DECLARE
    id_rota INT;
BEGIN
    SELECT COALESCE(MAX(id), 0) + 1 INTO id_rota FROM rota_caminhao;

    IF data_cheg >= CURRENT_DATE THEN
        IF EXISTS (SELECT 1 FROM caminhao WHERE id = id_cam) THEN
            INSERT INTO rota_caminhao (
                id, id_caminhao, status, distancia, destino_inicial, destino_final, data_chegada_prevista
            )
            VALUES (
                id_rota, id_cam, status_rota, distancia, dest_ini, dest_fim, data_cheg
            );
        ELSE
            RAISE EXCEPTION '[ERROR] Caminhão com ID % não encontrado!', id_cam;
        END IF;
    ELSE
        RAISE EXCEPTION '[ERROR] A data de chegada deve ser hoje ou futura!';
    END IF;
END;
$$;

CALL insert_empresa('TransLog', '12345678901234', 'contato@translog.com.br', 'senha123', 'Transportadora', 'Logística', 'TransLog LTDA', '4930-2/01', '(11)91234-5678', 'Rua do Caminhão, 123', 200, 50);

CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');
CALL insert_motorista(1, 'EMP001');

CALL insert_caminhao(10, 'AAA0001', 'Volvo FH', 1);
CALL insert_caminhao(12, 'AAA0002', 'Scania R', 2);
CALL insert_caminhao(14, 'AAA0003', 'Mercedes Axor', 3);
CALL insert_caminhao(15, 'AAA0004', 'DAF XF', 4);
CALL insert_caminhao(16, 'AAA0005', 'Iveco Stralis', 5);
CALL insert_caminhao(11, 'AAA0006', 'MAN TGX', 6);
CALL insert_caminhao(13, 'AAA0007', 'Volvo VM', 7);
CALL insert_caminhao(17, 'AAA0008', 'Scania G', 8);
CALL insert_caminhao(18, 'AAA0009', 'Mercedes Atego', 9);
CALL insert_caminhao(20, 'AAA0010', 'DAF CF', 10);

CALL insert_manutencao('Troca de óleo', 'Realizada em posto autorizado.', 1);
CALL insert_manutencao('Revisão dos freios', 'Verificação dos tambores.', 2);
CALL insert_manutencao('Calibração de pneus', 'Padrão 90psi traseiro.', 3);
CALL insert_manutencao('Troca de correia dentada', 'Item estava desgastado.', 4);
CALL insert_manutencao('Alinhamento', 'Alinhamento total e balanceamento.', 5);
CALL insert_manutencao('Substituição da bateria', 'Bateria com baixa carga.', 6);
CALL insert_manutencao('Troca do filtro de óleo', 'Filtro vencido.', 7);
CALL insert_manutencao('Inspeção elétrica', 'Faróis estavam queimados.', 8);
CALL insert_manutencao('Troca do óleo de freio', 'A cada 2 anos.', 9);
CALL insert_manutencao('Revisão completa', 'Checklist completo do caminhão.', 10);

CALL insert_alerta('PENDENTE', 'Sistema', 'Alerta de óleo', 'Nível de óleo abaixo do recomendado', 1);
CALL insert_alerta('PENDENTE', 'Motor', 'Superaquecimento', 'Temperatura excedeu 100°C', 2);
CALL insert_alerta('PENDENTE', 'Freios', 'Pastilhas gastas', 'Necessita troca imediata', 3);
CALL insert_alerta('PENDENTE', 'Bateria', 'Baixa voltagem', 'Tensão inferior a 12V', 4);
CALL insert_alerta('PENDENTE', 'Filtro', 'Filtro entupido', 'Fluxo de ar reduzido', 5);
CALL insert_alerta('PENDENTE', 'Combustível', 'Vazamento detectado', 'Verificar sistema', 6);
CALL insert_alerta('PENDENTE', 'Elétrica', 'Anomalia no alternador', 'Carga instável', 7);
CALL insert_alerta('PENDENTE', 'Pressão', 'Pneus descalibrados', 'Verificar pressão', 8);
CALL insert_alerta('PENDENTE', 'Injeção', 'Falha de combustível', 'Sensor irregular', 9);
CALL insert_alerta('PENDENTE', 'Sensor', 'Oxigênio fora do padrão', 'Valores anômalos', 10);


CALL insert_servico('Troca de óleo sintético', 350, '2025-10-01', '2025-10-02', 1);
CALL insert_servico('Verificação dos discos de freio', 200, '2025-10-02', '2025-10-03', 2);
CALL insert_servico('Balanceamento', 120, '2025-10-03', '2025-10-04', 3);
CALL insert_servico('Correia nova', 400, '2025-10-04', '2025-10-05', 4);
CALL insert_servico('Alinhamento técnico', 180, '2025-10-05', '2025-10-06', 5);
CALL insert_servico('Instalação de nova bateria', 450, '2025-10-06', '2025-10-07', 6);
CALL insert_servico('Filtro trocado', 90, '2025-10-07', '2025-10-08', 7);
CALL insert_servico('Nova fiação elétrica', 520, '2025-10-08', '2025-10-09', 8);
CALL insert_servico('Fluído de freio trocado', 130, '2025-10-09', '2025-10-10', 9);
CALL insert_servico('Revisão premium', 999, '2025-10-10', '2025-10-11', 10);

CALL insert_arduino(1, 60, 1500, 50, 20, 30, 6.5, 70, 'OK', 12000, 90, 35, 40, 120, 0.8, 0.7, 12.5, 'P0123', 'P0456', NOW());
CALL insert_arduino(2, 62, 1600, 55, 21, 35, 6.7, 72, 'OK', 12200, 91, 36, 42, 122, 0.9, 0.8, 12.6, 'P0130', 'P0440', NOW());
CALL insert_arduino(3, 65, 1700, 58, 23, 40, 7.0, 74, 'OK', 12500, 92, 37, 44, 124, 1.0, 0.9, 12.7, 'P0140', 'P0401', NOW());
CALL insert_arduino(4, 58, 1550, 60, 22, 33, 6.2, 71, 'OK', 12100, 89, 34, 39, 121, 0.7, 0.6, 12.4, 'P0110', 'P0442', NOW());
CALL insert_arduino(5, 70, 1800, 65, 24, 45, 7.5, 76, 'OK', 13000, 93, 38, 46, 125, 1.1, 1.0, 12.8, 'P0150', 'P0410', NOW());
CALL insert_arduino(6, 55, 1450, 45, 19, 28, 5.8, 69, 'OK', 11900, 88, 32, 37, 119, 0.6, 0.5, 12.3, 'P0105', 'P0420', NOW());
CALL insert_arduino(7, 68, 1750, 63, 25, 48, 7.2, 75, 'OK', 12800, 94, 39, 48, 126, 1.2, 1.1, 12.9, 'P0160', 'P0452', NOW());
CALL insert_arduino(8, 66, 1650, 60, 23, 42, 7.0, 73, 'OK', 12600, 90, 36, 43, 123, 0.8, 0.7, 12.6, 'P0138', 'P0460', NOW());
CALL insert_arduino(9, 63, 1600, 57, 21, 38, 6.8, 72, 'OK', 12400, 91, 35, 41, 122, 0.9, 0.8, 12.5, 'P0120', 'P0446', NOW());
CALL insert_arduino(10, 67, 1720, 61, 24, 44, 7.1, 74, 'OK', 12900, 95, 40, 49, 127, 1.0, 0.9, 13.0, 'P0141', 'P0412', NOW());

CALL insert_rota_caminhao(1, 'ATIVA', 300.5, 'São Paulo', 'Rio de Janeiro', '2025-10-22');
CALL insert_rota_caminhao(2, 'ATIVA', 180.0, 'Curitiba', 'Florianópolis', '2025-10-23');
CALL insert_rota_caminhao(3, 'ATIVA', 800.0, 'Porto Alegre', 'São Paulo', '2025-10-24');
CALL insert_rota_caminhao(4, 'ATIVA', 150.0, 'Belo Horizonte', 'Uberlândia', '2025-10-21');
CALL insert_rota_caminhao(5, 'ATIVA', 950.0, 'Recife', 'Salvador', '2025-10-25');
CALL insert_rota_caminhao(6, 'ATIVA', 400.0, 'Brasília', 'Goiânia', '2025-10-22');
CALL insert_rota_caminhao(7, 'ATIVA', 250.0, 'Campinas', 'Ribeirão Preto', '2025-10-23');
CALL insert_rota_caminhao(8, 'ATIVA', 500.0, 'Natal', 'Fortaleza', '2025-10-26');
CALL insert_rota_caminhao(9, 'ATIVA', 100.0, 'Londrina', 'Maringá', '2025-10-21');
CALL insert_rota_caminhao(10, 'ATIVA', 750.0, 'Manaus', 'Belém', '2025-10-27');


-- Procedure de Sessão
CREATE OR REPLACE PROCEDURE insert_sessao(
    p_id_usuario INT,
    p_tipo VARCHAR DEFAULT 'entrada'
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO sessao (id_usuario, tipo)
    VALUES (p_id_usuario, COALESCE(p_tipo, 'entrada'));
END;
$$;

CALL insert_sessao(1); -- tipo padrão 'entrada'
CALL insert_sessao(2, 'saida'); -- tipo definido manualmente

SELECT * FROM sessao;

-- Funções
-- Buscar Caminhão por ID do Motorista
CREATE OR REPLACE FUNCTION buscar_caminhao_por_motorista(p_id_motorista INTEGER)
RETURNS TABLE (
    id INTEGER,
    id_motorista INTEGER,
    status TEXT,
    capacidade INTEGER,
    placa TEXT,
    modelo TEXT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id, c.id_motorista, c.status::TEXT, c.capacidade, c.placa::TEXT, c.modelo::TEXT
    FROM caminhao c
    WHERE c.id_motorista = p_id_motorista;
END;
$$ LANGUAGE plpgsql;


-- Buscar Alertas Ativos por Caminhão
CREATE OR REPLACE FUNCTION buscar_alertas_ativos_por_caminhao(p_id_caminhao INTEGER)
RETURNS TABLE (
    id INTEGER,
    status BOOLEAN,
    id_caminhao INTEGER,
    descricao TEXT,
    titulo TEXT,
    categoria TEXT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id, a.status, a.id_caminhao, a.descricao::TEXT, a.titulo::TEXT, a.categoria::TEXT
    FROM alerta a
    WHERE a.id_caminhao = p_id_caminhao AND a.status = true;
END;
$$ LANGUAGE plpgsql;

-- Buscar Rotas Por Caminhao
CREATE OR REPLACE FUNCTION buscar_rotas_por_caminhao(p_id_caminhao INTEGER)
RETURNS TABLE (
    id INTEGER,
    id_caminhao INTEGER,
    status TEXT,
    destino_inicial TEXT,
    destino_final TEXT,
    distancia NUMERIC,
    data_chegada_prevista TIMESTAMP
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.id, r.id_caminhao, r.status::TEXT, r.destino_inicial::TEXT, r.destino_final::TEXT, r.distancia::NUMERIC, r.data_chegada_prevista::TIMESTAMP
    FROM rota_caminhao r
    WHERE r.id_caminhao = p_id_caminhao;
END;
$$ LANGUAGE plpgsql;


-- Buscar Manutencoes Por Caminhao
CREATE OR REPLACE FUNCTION buscar_manutencoes_por_caminhao(p_id_caminhao INTEGER)
RETURNS TABLE (
    id INTEGER,
    status BOOLEAN,
    id_caminhao INTEGER,
    info TEXT,
    titulo TEXT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.id, m.status, m.id_caminhao, m.info::TEXT, m.titulo::TEXT
    FROM manutencao m
    WHERE m.id_caminhao = p_id_caminhao;
END;
$$ LANGUAGE plpgsql;

-- Buscar Empresa Por ID
CREATE OR REPLACE FUNCTION buscar_empresa_por_id(p_id INTEGER)
RETURNS TABLE (
    id INTEGER,
    nome TEXT,
    cnpj TEXT,
    tamanho_empresa INTEGER,
    tamanho_frota INTEGER,
    tipo_empresa TEXT,
    area_atuacao TEXT,
    razao_social TEXT,
    cnae TEXT,
    telefone TEXT,
    endereco TEXT,
    cod_empresa TEXT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id, e.nome::TEXT, e.cnpj::TEXT, e.tamanho_empresa, e.tamanho_frota, e.tipo_empresa::TEXT, e.area_atuacao::TEXT, e.razao_social::TEXT, e.cnae::TEXT, e.telefone::TEXT, e.endereco::TEXT, e.cod_empresa::TEXT
    FROM empresa e
    WHERE e.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- Buscar Empresa Por Codigo
CREATE OR REPLACE FUNCTION buscar_empresa_por_codigo(p_cod_empresa TEXT)
RETURNS TABLE (
    id INTEGER,
    nome TEXT,
    cnpj TEXT,
    tamanho_empresa INTEGER,
    tamanho_frota INTEGER,
    tipo_empresa TEXT,
    area_atuacao TEXT,
    razao_social TEXT,
    cnae TEXT,
    telefone TEXT,
    endereco TEXT,
    cod_empresa TEXT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id, e.nome::TEXT, e.cnpj::TEXT, e.tamanho_empresa, e.tamanho_frota, e.tipo_empresa::TEXT, e.area_atuacao::TEXT, e.razao_social::TEXT, e.cnae::TEXT, e.telefone::TEXT, e.endereco::TEXT, e.cod_empresa::TEXT
    FROM empresa e
    WHERE e.cod_empresa = p_cod_empresa;
END;
$$ LANGUAGE plpgsql;

-- Buscar Arduino Por Caminhao
CREATE OR REPLACE FUNCTION buscar_arduino_por_caminhao(p_id_caminhao INTEGER)
RETURNS TABLE (
    id INTEGER,
    id_caminhao INTEGER,
    velocidade_veiculo NUMERIC,
    rotacoes_minuto_motor INT,
    carga_motor NUMERIC,
    tempo_motor_ligado INT,
    posicao_acelerador NUMERIC,
    consumo_combustivel NUMERIC,
    nivel_combustivel NUMERIC,
    status_sistema_combustivel TEXT,
    quilometragem NUMERIC,
    temperatura_liquido_arrefecimento NUMERIC,
    temperatura_ar_admissao NUMERIC,
    pressao_oleo_motor NUMERIC,
    pressao_coletor_admissao NUMERIC,
    leitura_sensores_oxigenio NUMERIC,
    leitura_sensor_oxigenio_2 NUMERIC,
    tensao_bateria NUMERIC,
    codigos_diagnostico_ativos TEXT,
    codigos_diagnostico_pendentes TEXT,
    data_hora_leitura TIMESTAMP
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id, a.id_caminhao, a.velocidade_veiculo, a.rotacoes_minuto_motor, a.carga_motor, a.tempo_motor_ligado, a.posicao_acelerador, a.consumo_combustivel, a.nivel_combustivel, a.status_sistema_combustivel::TEXT, a.quilometragem, a.temperatura_liquido_arrefecimento, a.temperatura_ar_admissao, a.pressao_oleo_motor, a.pressao_coletor_admissao, a.leitura_sensores_oxigenio, a.leitura_sensor_oxigenio_2, a.tensao_bateria, a.codigos_diagnostico_ativos::TEXT, a.codigos_diagnostico_pendentes::TEXT, a.data_hora_leitura
    FROM arduino a
    WHERE a.id_caminhao = p_id_caminhao;
END;
$$ LANGUAGE plpgsql;	

-- Buscar caminhão
SELECT * FROM buscar_caminhao_por_motorista(5);

-- Buscar alertas ativos
SELECT * FROM buscar_alertas_ativos_por_caminhao(3);

-- Testar com ID de caminhão 1
SELECT * FROM buscar_rotas_por_caminhao(1);

-- Testar com ID de caminhão 2
SELECT * FROM buscar_manutencoes_por_caminhao(2);

-- Testar com ID de empresa 3
SELECT * FROM buscar_empresa_por_id(3);

-- Testar com código da empresa fictício 'EMP123'
SELECT * FROM buscar_empresa_por_codigo('EMP123');

-- Testar com ID do caminhão 5
SELECT * FROM buscar_arduino_por_caminhao(5);

-- Testar com ID do caminhão 6
SELECT * FROM buscar_alertas_ativos_por_caminhao(6);

-- Índices
-- Índice para: buscar_caminhao_por_motorista
CREATE INDEX idx_caminhao_id_motorista ON caminhao (id_motorista);

-- Índice para: buscar_alertas_ativos_por_caminhao
CREATE INDEX idx_alerta_id_caminhao_status ON alerta (id_caminhao, status);

-- Índice para: buscar_rotas_por_caminhao
CREATE INDEX idx_rota_caminhao_id_caminhao ON rota_caminhao (id_caminhao);

-- Índice para: buscar_manutencoes_por_caminhao
CREATE INDEX idx_manutencao_id_caminhao ON manutencao (id_caminhao);

-- Índice para: buscar_empresa_por_id
CREATE INDEX idx_empresa_id ON empresa (id);

-- Índice para: buscar_empresa_por_codigo
CREATE INDEX idx_empresa_cod_empresa ON empresa (cod_empresa);

-- Índice para: buscar_arduino_por_caminhao
CREATE INDEX idx_arduino_id_caminhao ON arduino (id_caminhao);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_atualizado_em_coluna()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_fcm_tokens_atualizado_em 
    BEFORE UPDATE ON fcm_tokens 
    FOR EACH ROW 
    EXECUTE FUNCTION update_atualizado_em_coluna();