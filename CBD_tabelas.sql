-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de tabelas


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating tables...');


CREATE TABLE PROJETO.area_atuacao
(
    id_area_atuacao INTEGER,
    descricao       VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_area_atuacao PRIMARY KEY (id_area_atuacao),
    CONSTRAINT uq_area_atuacao_descricao UNIQUE (descricao)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.tipo_cirurgia
(
    id_tipo_cirurgia INTEGER,
    id_area_atuacao  INTEGER,
    nome             VARCHAR2(150) NOT NULL,
    CONSTRAINT pk_tipo_cirurgia PRIMARY KEY (id_tipo_cirurgia),
    CONSTRAINT fk_tipo_cirurgia_area_atuacao FOREIGN KEY (id_area_atuacao) REFERENCES area_atuacao (id_area_atuacao),
    CONSTRAINT uq_tipo_cirurgia_nome UNIQUE (nome)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.estado_paciente
(
    id_estado_paciente INTEGER,
    descricao          VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_estado_paciente PRIMARY KEY (id_estado_paciente)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.pessoa
(
    nif       NUMBER(9),
    prim_nome VARCHAR2(30)  NOT NULL,
    ult_nome  VARCHAR2(30)  NOT NULL,
    morada    VARCHAR2(200) NOT NULL,
    dta_nasc  DATE          NOT NULL,
    CONSTRAINT pk_pessoa PRIMARY KEY (nif)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.telefone
(
    nif      NUMBER(9),
    telefone VARCHAR2(9),
    CONSTRAINT pk_telefone PRIMARY KEY (nif, telefone),
    CONSTRAINT fk_telefone_pessoa FOREIGN KEY (nif) REFERENCES pessoa
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.funcionario
(
    nif NUMBER(9),
    CONSTRAINT pk_funcionario PRIMARY KEY (nif),
    CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (nif) REFERENCES pessoa (nif)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.enfermeiro
(
    nif NUMBER(9),
    CONSTRAINT pk_enfermeiro PRIMARY KEY (nif),
    CONSTRAINT fk_enfermeiro_funcionario FOREIGN KEY (nif) REFERENCES funcionario (nif)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.medico
(
    nif             NUMBER(9),
    id_area_atuacao INTEGER,
    cedula          VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (nif),
    CONSTRAINT fk_medico_funcionario FOREIGN KEY (nif)
        REFERENCES funcionario (nif),
    CONSTRAINT fk_medico_area_atuacao FOREIGN KEY (id_area_atuacao)
        REFERENCES area_atuacao (id_area_atuacao),
    CONSTRAINT uq_medico_cedula UNIQUE (cedula)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.paciente
(
    nif            NUMBER(9),
    n_utente_saude NUMBER(9) NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (nif),
    CONSTRAINT fk_paciente_pessoa FOREIGN KEY (nif)
        REFERENCES pessoa (nif),
    CONSTRAINT uq_paciente_n_utente_saude UNIQUE (n_utente_saude)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.relatorio
(
    id_relatorio INTEGER,
    nif          NUMBER(9),
    texto        VARCHAR2(2400),
    categoria    CHAR(3) NOT NULL,
    CONSTRAINT pk_relatorio PRIMARY KEY (id_relatorio),
    CONSTRAINT fk_relatorio_funcionario FOREIGN KEY (nif)
        REFERENCES funcionario (nif),
    CONSTRAINT ck_relatorio_categoria CHECK (categoria IN ('CON', 'CIR'))
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.processo
(
    id_processo      INTEGER,
    nif                NUMBER(9),
    id_area_atuacao    INTEGER,
    id_estado_paciente INTEGER,
    dta_inicio         DATE,
    dta_alta           DATE,
    CONSTRAINT pk_processo PRIMARY KEY (id_processo),
    /*
    Esta constraint é deferida para permitir a inserção do processo antes do paciente
    para validar no trigger after insert do paciente se existe um processo associado a ele.
     */
    CONSTRAINT fk_processo_paciente FOREIGN KEY (nif)
        REFERENCES paciente (nif) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_processo_area_atuacao FOREIGN KEY (id_area_atuacao)
        REFERENCES area_atuacao (id_area_atuacao)
) PARTITION BY LIST (dta_alta)
(
    PARTITION ativos VALUES (NULL) TABLESPACE tbs_tables,
    PARTITION arquivados VALUES (default) TABLESPACE tbs_tables
) ENABLE ROW MOVEMENT
TABLESPACE tbs_tables;


CREATE TABLE PROJETO.consulta
(
    id_consulta        INTEGER,
    id_processo      INTEGER,
    nif_funcionario    NUMBER(9),
    id_relatorio       INTEGER,
    id_estado_paciente INTEGER,
    dta_realizacao     DATE,
    CONSTRAINT pk_consulta PRIMARY KEY (id_consulta),
    CONSTRAINT fk_consulta_processo FOREIGN KEY (id_processo)
        REFERENCES processo (id_processo),
    CONSTRAINT fk_consulta_funcionario FOREIGN KEY (nif_funcionario)
        REFERENCES funcionario (nif),
    CONSTRAINT fk_consulta_relatorio FOREIGN KEY (id_relatorio)
        REFERENCES relatorio (id_relatorio),
    CONSTRAINT fk_consulta_estado_paciente FOREIGN KEY (id_estado_paciente)
        REFERENCES estado_paciente (id_estado_paciente)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.cirurgia
(
    id_cirurgia      INTEGER,
    id_processo    INTEGER,
    id_relatorio     INTEGER,
    id_tipo_cirurgia INTEGER,
    dta_realizacao   DATE,
    CONSTRAINT pk_cirurgia PRIMARY KEY (id_cirurgia),
    CONSTRAINT fk_cirurgia_processo FOREIGN KEY (id_processo)
        REFERENCES processo (id_processo),
    CONSTRAINT fk_cirurgia_relatorio FOREIGN KEY (id_relatorio)
        REFERENCES relatorio (id_relatorio),
    CONSTRAINT fk_cirurgia_tipo_cirurgia FOREIGN KEY (id_tipo_cirurgia)
        REFERENCES tipo_cirurgia (id_tipo_cirurgia)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.medico_cirurgia
(
    nif         NUMBER(9),
    id_cirurgia INTEGER,
    CONSTRAINT pk_medico_cirurgia PRIMARY KEY (nif, id_cirurgia),
    CONSTRAINT fk_medico_cirurgia_medico FOREIGN KEY (nif)
        REFERENCES medico (nif),
    CONSTRAINT fk_medico_cirurgia_cirurgia FOREIGN KEY (id_cirurgia)
        REFERENCES cirurgia (id_cirurgia)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.user_exception (
    code INT,
    name VARCHAR2(60),
    errm VARCHAR2(200),
    CONSTRAINT pk_user_exception PRIMARY KEY (code),
    CONSTRAINT uq_user_exception_name UNIQUE (name)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.exception_log (
    id_exception_log INTEGER,
    code INTEGER,
    logged_at TIMESTAMP(2),
    errm VARCHAR2(500),
    stacktrace VARCHAR2(500),
    CONSTRAINT pk_exception_log PRIMARY KEY (id_exception_log)
) TABLESPACE tbs_tables;


CREATE TABLE PROJETO.encryption_key (
		key VARCHAR2(200),
		CONSTRAINT pk_encryption_key PRIMARY KEY (key)
) TABLESPACE tbs_tables;

