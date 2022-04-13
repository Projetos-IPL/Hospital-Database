CREATE OR REPLACE PACKAGE et_consulta AS

    ex_consulta_em_tratamento_finalizado EXCEPTION;
    ex_consulta_em_tratamento_finalizado_error_code INT := -20799;
    ex_consulta_em_tratamento_finalizado_errm VARCHAR2(100) := 'Tentativa de registo de consulta em tratamento já finalizado.';

    ex_alteracao_consulta EXCEPTION;
    ex_alteracao_consulta_error_code INT := -20798;
    ex_alteracao_consulta_errm VARCHAR2(100) := 'Tentativa de alteração de consulta.';

    -- Procedimento para registar uma consulta
    PROCEDURE registar_consulta(
        p_id_tratamento      IN consulta.id_tratamento%TYPE,
        p_nif_funcionario    IN consulta.nif_funcionario%TYPE,
        p_id_estado_paciente IN consulta.id_estado_paciente%TYPE,
        p_relatorio          IN VARCHAR2);

    -- Procedimento para validar se é permitido registar uma nova consulta a um tratamento
    FUNCTION validar_nova_consulta(
        p_id_tratamento      IN consulta.id_tratamento%TYPE)
    RETURN BOOLEAN;

END et_consulta;