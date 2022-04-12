CREATE OR REPLACE PACKAGE et_tratamento AS

    /**
      Procedimento para registar tratamentos
     */
    PROCEDURE registar_tratamento(
        p_id_tratamento      IN tratamento.id_tratamento%TYPE,
        p_nif                IN tratamento.nif%TYPE,
        p_id_area_atuacao    IN tratamento.id_area_atuacao%TYPE,
        p_id_estado_paciente IN tratamento.id_estado_paciente%TYPE
    );

END et_tratamento;
/