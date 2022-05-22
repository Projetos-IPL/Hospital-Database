-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de sequências


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating sequences...');

-- Área de atuação
CREATE SEQUENCE PROJETO.pk_area_atuacao_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCACHE;


-- Relatório
CREATE SEQUENCE PROJETO.pk_relatorio_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;


-- processo
CREATE SEQUENCE PROJETO.pk_processo_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;


-- Tipo de Cirurgia
CREATE SEQUENCE PROJETO.pk_tipo_cirurgia_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCACHE;
    

-- Cirurgia
CREATE SEQUENCE PROJETO.pk_cirurgia_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;
    

-- Consulta
CREATE SEQUENCE PROJETO.pk_consulta_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;


-- Estado do Paciente
CREATE SEQUENCE PROJETO.pk_estado_paciente_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    NOCACHE;


-- Histórico de Exceções
CREATE SEQUENCE PROJETO.pk_exception_log_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    NOCACHE;


COMMIT;
