CREATE OR REPLACE PACKAGE et_cirurgia AS

    ex_alteracao_cirurgia EXCEPTION;

    -- Registar uma nova cirurgia, associando a um tratamento
    PROCEDURE registar_cirurgia(
        p_id_tratamento         IN tratamento.id_tratamento%TYPE,
        p_id_tipo_cirurgia      IN tipo_cirurgia.id_tipo_cirurgia%TYPE,
        p_nif_medico            IN medico.nif%TYPE,
        p_relatorio             IN relatorio.texto%TYPE
    );

END et_cirurgia;