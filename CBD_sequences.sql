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


-- processo
CREATE SEQUENCE pk_processo_seq
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


-- Estado do Paciente
CREATE SEQUENCE pk_estado_paciente_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCACHE;


-- Histórico de Exceções
CREATE SEQUENCE pk_exception_log_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;


COMMIT;