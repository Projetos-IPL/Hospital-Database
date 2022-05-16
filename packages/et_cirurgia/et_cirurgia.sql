-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Cabeçalho do pacote ET_CIRURGIA

CREATE OR REPLACE PACKAGE et_cirurgia AS

    ex_area_atuacao_nao_corresponde EXCEPTION;
    ex_alteracao_cirurgia EXCEPTION;
    ex_cirurgia_em_processo_finalizado EXCEPTION;

    -- Procedimento registar uma nova cirurgia, associando a um processo
    PROCEDURE registar_cirurgia(
        p_id_processo         IN cirurgia.id_processo%TYPE,
        p_id_tipo_cirurgia      IN cirurgia.id_tipo_cirurgia%TYPE,
        p_relatorio             IN relatorio.texto%TYPE,
        p_t_nif_medicos         IN et_pessoa.t_nif);

    -- Função para validar nova cirurgia, se for inválida lança as devidas exceções.
    -- Uma cirurgia não é válida quando a área de atuação do processo não corresponde à do tipo cirurgia.
    PROCEDURE validar_cirurgia(
        p_id_processo       IN cirurgia.id_processo%TYPE,
        p_id_tipo_cirurgia    IN cirurgia.id_tipo_cirurgia%TYPE,
        p_t_nif_medicos       IN et_pessoa.t_nif);

END et_cirurgia;
/