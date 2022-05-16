-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Cabeçalho do pacote ET_PROCESSO

CREATE OR REPLACE PACKAGE et_processo AS

    -- Exceções
    ex_processo_repetido EXCEPTION;
    ex_processo_nao_encontrado EXCEPTION;
    ex_processo_ja_finalizado EXCEPTION;
    ex_alteracao_invalida EXCEPTION;
    ex_paciente_ja_tem_processo EXCEPTION;

    -- Procedimento para registar processos
    PROCEDURE registar_processo(
        p_nif                IN processo.nif%TYPE,
        p_id_area_atuacao    IN processo.id_area_atuacao%TYPE);

    /* Procedimento para registar o primeiro processo, a diferença entre o registar
        processo e este procedimento é que esta não faz commit à transação */
    PROCEDURE registar_primeiro_processo(
        p_nif                IN processo.nif%TYPE,
        p_id_area_atuacao    IN processo.id_area_atuacao%TYPE);

    -- Procedimento para finalizar processo
    PROCEDURE finalizar_processo(
        p_id_processo IN processo.id_processo%TYPE);

    -- Procedimento para validar alterações num processo.
    -- Devolve TRUE se as alterações respeitarem os requisitos.
    FUNCTION validar_alteracao(
        p_rec_novo_trat     IN processo%rowtype,
        p_rec_antigo_trat   IN processo%rowtype)
    RETURN BOOLEAN;

    -- Procedimento para atualizar o estado de um paciente
    PROCEDURE atualizar_estado_processo(
        p_id_processo processo.id_processo%TYPE,
        p_id_estado_paciente processo.id_estado_paciente%TYPE);

    -- Procedimento para validar um novo processo
    PROCEDURE validar_novo_processo(p_rec_processo IN processo%rowtype);

    -- Procedimento para imprimir o registo de erros
    PROCEDURE print_error_log;

    -- Procedimento para limpar a variável de registo de erros
    PROCEDURE limpar_error_log;

    -- Função para obter um VARCHAR2 com o registo de erros
    FUNCTION obter_error_log RETURN VARCHAR2;

END et_processo;
/