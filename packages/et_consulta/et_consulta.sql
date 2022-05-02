CREATE OR REPLACE PACKAGE et_consulta AS

    ex_consulta_em_processo_finalizado EXCEPTION;
    ex_alteracao_consulta EXCEPTION;

    -- Procedimento para registar uma consulta
    PROCEDURE registar_consulta(
        p_id_processo      IN consulta.id_processo%TYPE,
        p_nif_funcionario    IN consulta.nif_funcionario%TYPE,
        p_id_estado_paciente IN consulta.id_estado_paciente%TYPE,
        p_relatorio          IN VARCHAR2);

    -- Procedimento para validar se é permitido registar uma nova consulta a um processo
    FUNCTION validar_nova_consulta(
        p_id_processo      IN consulta.id_processo%TYPE)
    RETURN BOOLEAN;


END et_consulta;
/