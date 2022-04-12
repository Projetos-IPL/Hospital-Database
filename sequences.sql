/*
********************************************************

    DEFINIÇÃO DE SEQUENCES

    Afonso Santos, Iúri Raimundo
    Deloitte Delivery Center S.A - Brightstart

*********************************************************
*/


-- Área de atuação
CREATE SEQUENCE pk_area_atuacao_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCACHE;


-- Relatório
CREATE SEQUENCE pk_relatorio_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;


-- Tratamento
CREATE SEQUENCE pk_tratamento_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;


-- Tipo de Cirurgia
CREATE SEQUENCE pk_tipo_cirurgia_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCACHE;
    

-- Cirurgia
CREATE SEQUENCE pk_cirurgia_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;
    

-- Consulta
CREATE SEQUENCE pk_consulta_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;


COMMIT;