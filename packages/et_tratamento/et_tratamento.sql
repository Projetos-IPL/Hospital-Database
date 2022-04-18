CREATE OR REPLACE PACKAGE et_tratamento AS

    -- Exceções
    ex_tratamento_repetido EXCEPTION;
    ex_tratamento_nao_encontrado EXCEPTION;
    ex_tratamento_ja_finalizado EXCEPTION;
    ex_alteracao_invalida EXCEPTION;
    ex_paciente_ja_tem_tratamento EXCEPTION;

    -- Procedimento para registar tratamentos
    PROCEDURE registar_tratamento(
        p_nif                IN tratamento.nif%TYPE,
        p_id_area_atuacao    IN tratamento.id_area_atuacao%TYPE);

    /* Procedimento para registar o primeiro tratamento, a diferença entre o registar
        tratamento e este procedimento é que esta não faz commit à transação */
    PROCEDURE registar_primeiro_tratamento(
        p_nif                IN tratamento.nif%TYPE,
        p_id_area_atuacao    IN tratamento.id_area_atuacao%TYPE);

    -- Procedimento para finalizar tratamento
    PROCEDURE finalizar_tratamento(
        p_id_tratamento IN tratamento.id_tratamento%TYPE);

    -- Procedimento para validar alterações num tratamento.
    -- Devolve TRUE se as alterações respeitarem os requisitos.
    FUNCTION validar_alteracao(
        p_rec_novo_trat     IN tratamento%rowtype,
        p_rec_antigo_trat   IN tratamento%rowtype)
    RETURN BOOLEAN;

    -- Procedimento para atualizar o estado de um paciente
    PROCEDURE atualizar_estado_tratamento(
        p_id_tratamento tratamento.id_tratamento%TYPE,
        p_id_estado_paciente tratamento.id_estado_paciente%TYPE);

    -- Procedimento para imprimir o registo de erros
    PROCEDURE print_error_log;

    -- Procedimento para limpar a variável de registo de erros
    PROCEDURE limpar_error_log;

    -- Função para obter um VARCHAR2 com o registo de erros
    FUNCTION obter_error_log RETURN VARCHAR2;

END et_tratamento;
/