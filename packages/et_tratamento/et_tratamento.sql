CREATE OR REPLACE PACKAGE et_tratamento AS

    -- Exceções
    ex_tratamento_repetido EXCEPTION;
    ex_tratamento_repetido_error_code INT := -20998;
    ex_tratamento_repetido_errm VARCHAR2(100) := 'Tentativa de abertura de tratamento repetido para paciente com nif: ';

    ex_tratamento_nao_encontrado EXCEPTION;
    ex_tratamento_nao_encontrado_error_code INT := -20997;
    ex_tratamento_nao_encontrado_errm VARCHAR2(100) := 'Tratamento não encontrado.';

    ex_finalizacao_repetida EXCEPTION;
    ex_finalizacao_repetida_error_code INT := -20996;
    ex_finalizacao_repetida_errm VARCHAR2(100) := 'Tentativa de finalizar tratamento já finalizado. Tratamento: ';

    ex_alteracao_invalida EXCEPTION;
    ex_alteracao_invalida_error_code INT := -20995;
    ex_alteracao_invalida_errm VARCHAR2(100) := 'Tentativa de alteração do tratamento onão permitida';

    -- Procedimento para registar tratamentos
    PROCEDURE registar_tratamento(
        p_nif                IN tratamento.nif%TYPE,
        p_id_area_atuacao    IN tratamento.id_area_atuacao%TYPE);

    -- Procedimento para finalizar tratamento
    PROCEDURE finalizar_tratamento(
        p_id_tratamento IN tratamento.id_tratamento%TYPE);

    /** Procedimento para validar alterações num tratamento.
      Devolve TRUE se as alterações respeitarem os requisitos. */
    FUNCTION validar_alteracao(
        p_rec_novo_trat     IN tratamento%rowtype,
        p_rec_antigo_trat   IN tratamento%rowtype)
    RETURN BOOLEAN;

    -- Procedimento para imprimir o registo de erros
    PROCEDURE print_error_log;

END et_tratamento;
/