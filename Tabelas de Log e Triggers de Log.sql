-- Drops
DROP TABLE IF EXISTS log_motorista CASCADE;
DROP TABLE IF EXISTS log_manutencao CASCADE;
DROP TABLE IF EXISTS log_alerta CASCADE;
DROP TABLE IF EXISTS log_caminhao CASCADE;
DROP TABLE IF EXISTS log_arduino CASCADE;
DROP TABLE IF EXISTS log_servico CASCADE;
DROP TABLE IF EXISTS log_empresa CASCADE;
DROP TABLE IF EXISTS log_rota_caminhao CASCADE;

-- Script Tabelas de Log
CREATE TABLE log_motorista (
 log_motorista_id SERIAL PRIMARY KEY,
 cod_motorista INT,
 data_alteracao DATE NOT NULL,
 operacao varchar(80),
 usuario varchar(80),
 delete_old varchar(14) 
);

CREATE TABLE log_manutencao (
 log_manutencao_id SERIAL PRIMARY KEY,
 cod_manutencao INT,
 data_alteracao DATE NOT NULL,
 operacao varchar(80),
 usuario varchar(80),
 delete_old varchar(14) 
);

CREATE TABLE log_alerta (
 log_alerta_id SERIAL PRIMARY KEY,
 cod_alerta INT,
 data_alteracao DATE NOT NULL,
 operacao varchar(80),
 usuario varchar(80),
 delete_old varchar(14) 
);

CREATE TABLE log_caminhao (
 log_caminhao_id SERIAL PRIMARY KEY,
 cod_caminhao INT,
 data_alteracao DATE NOT NULL,
 operacao varchar(80),
 usuario varchar(80),
 delete_old varchar(14) 
);

CREATE TABLE log_arduino (
 log_arduino_id SERIAL PRIMARY KEY,
 cod_arduino INT,
 data_alteracao DATE NOT NULL,
 operacao varchar(80),
 usuario varchar(80),
 delete_old varchar(14) 
);

CREATE TABLE log_servico (
 log_servico_id SERIAL PRIMARY KEY,
 cod_servico INT,
 data_alteracao DATE NOT NULL,
 operacao varchar(80),
 usuario varchar(80),
 delete_old varchar(14) 
);

CREATE TABLE log_empresa (
 log_empresa_id SERIAL PRIMARY KEY,
 cod_empresa INT,
 data_alteracao DATE NOT NULL,
 operacao varchar(80),
 usuario varchar(80),
 delete_old varchar(14) 
);

CREATE TABLE log_rota_caminhao (
 log_rota_caminhao_id SERIAL PRIMARY KEY,
 cod_rota_caminhao INT,
 data_alteracao DATE NOT NULL,
 operacao varchar(80),
 usuario varchar(80),
 delete_old varchar(14) 
);

SELECT * FROM log_motorista;
SELECT * FROM log_manutencao;
SELECT * FROM log_caminhao;
SELECT * FROM log_arduino;
SELECT * FROM log_servico;
SELECT * FROM log_empresa;
SELECT * FROM log_rota_caminhao;

-- Funções de Trigger
-- Motorista
CREATE OR REPLACE FUNCTION func_log_motorista()
RETURNS TRIGGER AS
$$
	DECLARE
		usuario VARCHAR(80);
	BEGIN
		SELECT usename FROM pg_user INTO usuario;
		
		INSERT INTO log_motorista (cod_motorista, data_alteracao, operacao, usuario, delete_old)
		VALUES (new.id, CURRENT_DATE, TG_OP, usuario, old.id);

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_motorista
AFTER INSERT OR UPDATE OR DELETE ON motorista
FOR EACH ROW
EXECUTE PROCEDURE func_log_motorista();

-- Manutenção
CREATE OR REPLACE FUNCTION func_log_manutencao()
RETURNS TRIGGER AS
$$
	DECLARE
		usuario VARCHAR(80);
	BEGIN
		SELECT usename FROM pg_user INTO usuario;
		
		INSERT INTO log_manutencao (cod_manutencao, data_alteracao, operacao, usuario, delete_old)
		VALUES (new.id, CURRENT_DATE, TG_OP, usuario, old.id);

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_manutencao
AFTER INSERT OR UPDATE OR DELETE ON manutencao
FOR EACH ROW
EXECUTE PROCEDURE func_log_manutencao();

-- Alerta
CREATE OR REPLACE FUNCTION func_log_alerta()
RETURNS TRIGGER AS
$$
	DECLARE
		usuario VARCHAR(80);
	BEGIN
		SELECT usename FROM pg_user INTO usuario;
		
		INSERT INTO log_alerta (cod_alerta, data_alteracao, operacao, usuario, delete_old)
		VALUES (new.id, CURRENT_DATE, TG_OP, usuario, old.id);

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_alerta
AFTER INSERT OR UPDATE OR DELETE ON alerta
FOR EACH ROW
EXECUTE PROCEDURE func_log_alerta();

-- Caminhão
CREATE OR REPLACE FUNCTION func_log_caminhao()
RETURNS TRIGGER AS
$$
	DECLARE
		usuario VARCHAR(80);
	BEGIN
		SELECT usename FROM pg_user INTO usuario;
		
		INSERT INTO log_caminhao (cod_caminhao, data_alteracao, operacao, usuario, delete_old)
		VALUES (new.id, CURRENT_DATE, TG_OP, usuario, old.id);
		
		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_caminhao
AFTER INSERT OR UPDATE OR DELETE ON caminhao
FOR EACH ROW
EXECUTE PROCEDURE func_log_caminhao();

-- Arduino
CREATE OR REPLACE FUNCTION func_log_arduino()
RETURNS TRIGGER AS
$$
	DECLARE
		usuario VARCHAR(80);
	BEGIN
		SELECT usename FROM pg_user INTO usuario;
		
		INSERT INTO log_arduino (cod_arduino, data_alteracao, operacao, usuario, delete_old)
		VALUES (new.id, CURRENT_DATE, TG_OP, usuario, old.id);

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_arduino
AFTER INSERT OR UPDATE OR DELETE ON arduino
FOR EACH ROW
EXECUTE PROCEDURE func_log_arduino();

-- Serviço
CREATE OR REPLACE FUNCTION func_log_servico()
RETURNS TRIGGER AS
$$
	DECLARE
		usuario VARCHAR(80);
	BEGIN
		SELECT usename FROM pg_user INTO usuario;
		
		INSERT INTO log_servico (cod_servico, data_alteracao, operacao, usuario, delete_old)
		VALUES (new.id, CURRENT_DATE, TG_OP, usuario, old.id);

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_servico
AFTER INSERT OR UPDATE OR DELETE ON servico
FOR EACH ROW
EXECUTE PROCEDURE func_log_servico();

-- Empresa
CREATE OR REPLACE FUNCTION func_log_empresa()
RETURNS TRIGGER AS
$$
	DECLARE
		usuario VARCHAR(80);
	BEGIN
		SELECT usename FROM pg_user INTO usuario;
		
		INSERT INTO log_empresa (cod_empresa, data_alteracao, operacao, usuario, delete_old)
		VALUES (new.id, CURRENT_DATE, TG_OP, usuario, old.id);

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_empresa
AFTER INSERT OR UPDATE OR DELETE ON empresa
FOR EACH ROW
EXECUTE PROCEDURE func_log_empresa();

-- rota_caminhao
CREATE OR REPLACE FUNCTION func_log_rota_caminhao()
RETURNS TRIGGER AS
$$
	DECLARE
		usuario VARCHAR(80);
	BEGIN
		SELECT usename FROM pg_user INTO usuario;
		
		INSERT INTO log_rota_caminhao (cod_rota_caminhao, data_alteracao, operacao, usuario, delete_old)
		VALUES (new.id, CURRENT_DATE, TG_OP, usuario, old.id);

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_log_rota_caminhao
AFTER INSERT OR UPDATE OR DELETE ON rota_caminhao
FOR EACH ROW
EXECUTE PROCEDURE func_log_rota_caminhao();

-- Triggers para as tabelas intermediarias
-- Trigger Function motorista_caminhao
CREATE OR REPLACE FUNCTION trg_insert_motorista_caminhao()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO motorista_caminhao (id_motorista, id_caminhao)
    VALUES (NEW.id_motorista, NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger motorista_caminhao
CREATE TRIGGER trg_motorista_caminhao_after_insert
AFTER INSERT ON caminhao
FOR EACH ROW
EXECUTE FUNCTION trg_insert_motorista_caminhao();

-- Trigger Function caminhao_manutencao
CREATE OR REPLACE FUNCTION trg_insert_caminhao_manutencao()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO caminhao_manutencao (id_caminhao, id_manutencao)
    VALUES (NEW.id_caminhao, NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger caminhao_manutencao
CREATE TRIGGER trg_caminhao_manutencao_after_insert
AFTER INSERT ON manutencao
FOR EACH ROW
EXECUTE FUNCTION trg_insert_caminhao_manutencao();

-- Trigger Function motorista_empresa
CREATE OR REPLACE FUNCTION trg_insert_motorista_empresa()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO motorista_empresa (id_motorista, id_empresa)
    VALUES (NEW.id, NEW.id_empresa);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger motorista_empresa
CREATE TRIGGER trg_motorista_empresa_after_insert
AFTER INSERT ON motorista
FOR EACH ROW
EXECUTE FUNCTION trg_insert_motorista_empresa();
