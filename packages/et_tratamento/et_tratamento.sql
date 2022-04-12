CREATE OR REPLACE PACKAGE et_tratamento AS

    ex_tratamento_repetido EXCEPTION;
    ex_tratamento_repetido_error_code INT := -20998;
    ex_tratamento_repetido_errm VARCHAR2(100) := 'Tentativa de abertura de tratamento repetido para paciente com nif: ';

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
        p_id_tratamento IN tratamento.id_tratamento%TYPE
    );

END et_tratamento;
/