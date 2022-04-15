CREATE OR REPLACE PACKAGE et_cirurgia AS

    ex_area_atuacao_nao_corresponde EXCEPTION;

    -- Procedimento registar uma nova cirurgia, associando a um tratamento
    PROCEDURE registar_cirurgia(
        p_id_tratamento         IN cirurgia.id_tratamento%TYPE,
        p_id_tipo_cirurgia      IN cirurgia.id_tipo_cirurgia%TYPE,
        p_relatorio             IN relatorio.texto%TYPE,
        p_t_nif                 IN et_pessoa.t_nif);

    /*
    Função para validar nova cirurgia, devolve TRUE se for válida, devolve FALSE se não for.
    Uma cirurgia não é válida quando
     */
    FUNCTION validar_cirurgia(
        p_id_tratamento       IN cirurgia.id_tratamento%TYPE,
        p_id_tipo_cirurgia    IN cirurgia.id_tipo_cirurgia%TYPE,
        p_t_nif               IN et_pessoa.t_nif)
    RETURN BOOLEAN;

END et_cirurgia;