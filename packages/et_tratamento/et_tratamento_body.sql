CREATE PACKAGE BODY et_tratamento AS

    PROCEDURE registar_tratamento(
        p_id_tratamento      IN tratamento.id_tratamento%TYPE,
        p_nif                IN tratamento.nif%TYPE,
        p_id_area_atuacao    IN tratamento.id_area_atuacao%TYPE,
        p_id_estado_paciente IN tratamento.id_estado_paciente%TYPE
    )
    IS
    BEGIN

    END;



END et_tratamento;
/