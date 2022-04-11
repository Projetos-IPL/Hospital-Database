/*
********************************************************

    DEFINIÇÃO DE TABELAS E CONTRAINTS

    Afonso Santos, Iúri Raimundo
    Deloitte Delivery Center S.A - Brightstart

*********************************************************
*/

CREATE TABLE area_atuacao
(
    id_area_atuacao INT,
    descricao       VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_area_atuacao PRIMARY KEY (id_area_atuacao),
    CONSTRAINT uq_area_atuacao_descricao UNIQUE (descricao)
);
/


CREATE TABLE tipo_cirurgia
(
    id_tipo_cirurgia INT,
    nome             VARCHAR2(50),
    id_area_atuacao  INT,
    CONSTRAINT pk_tipo_cirurgia PRIMARY KEY (id_tipo_cirurgia),
    CONSTRAINT fk_tipo_cirurgia FOREIGN KEY (id_area_atuacao) REFERENCES area_atuacao (id_area_atuacao),
    CONSTRAINT uq_tipo_cirurgia_nome UNIQUE (nome)
);
/


CREATE TABLE pessoa
(
    nif NUMBER(9),
    prim_nome VARCHAR2(30),
    ult_nome VARCHAR2(30),
    morada VARCHAR2(200),
    telefone VARCHAR2(9),
    CONSTRAINT pk_pessoa PRIMARY KEY (nif)
);
/






