CREATE OR REPLACE PACKAGE et_consulta AS

    PROCEDURE registar_consulta(
        p_id_tratamento      IN consulta.id_tratamento%TYPE,
        p_nif_funcionario    IN consulta.nif_funcionario%TYPE,
        p_id_estado_paciente IN consulta.id_estado_paciente%TYPE,
        p_relatorio          IN VARCHAR2
    );

END et_consulta;