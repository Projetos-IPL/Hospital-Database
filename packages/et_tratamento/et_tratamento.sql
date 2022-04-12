CREATE OR REPLACE PACKAGE et_tratamento AS

    /**
      Procedimento para registar tratamentos
     */
    PROCEDURE registar_tratamento(
        p_nif                IN tratamento.nif%TYPE,
        p_id_area_atuacao    IN tratamento.id_area_atuacao%TYPE
    );

    /**
      Procedimento para finalizar tratamento
     */
    PROCEDURE finalizar_tratamento(
        p_id_tratamento IN tratamento.id_tratamnto%TYPE
    );

END et_tratamento;
/