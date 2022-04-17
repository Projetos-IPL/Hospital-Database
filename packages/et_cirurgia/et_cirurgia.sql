CREATE OR REPLACE PACKAGE et_cirurgia AS

    ex_area_atuacao_nao_corresponde EXCEPTION;
    ex_alteracao_cirurgia EXCEPTION;
    ex_cirurgia_em_tratamento_finalizado EXCEPTION;

    -- Procedimento registar uma nova cirurgia, associando a um tratamento
    PROCEDURE registar_cirurgia(
        p_id_tratamento         IN cirurgia.id_tratamento%TYPE,
        p_id_tipo_cirurgia      IN cirurgia.id_tipo_cirurgia%TYPE,
        p_relatorio             IN relatorio.texto%TYPE,
        p_t_nif_medicos                 IN et_pessoa.t_nif);

    -- Função para validar nova cirurgia, se for inválida lança as devidas exceções.
    -- Uma cirurgia não é válida quando a área de atuação do tratamento não corresponde à do tipo cirurgia.
    PROCEDURE validar_cirurgia(
        p_id_tratamento       IN cirurgia.id_tratamento%TYPE,
        p_id_tipo_cirurgia    IN cirurgia.id_tipo_cirurgia%TYPE,
        p_t_nif_medicos       IN et_pessoa.t_nif);

END et_cirurgia;
/