-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Cabeçalho do pacote ET_CONSULTA

CREATE OR REPLACE PACKAGE et_consulta AS

    ex_consulta_em_processo_finalizado EXCEPTION;
    ex_alteracao_consulta EXCEPTION;

    -- Procedimento para registar uma consulta
    PROCEDURE registar_consulta(
        p_id_processo      IN consulta.id_processo%TYPE,
        p_nif_funcionario    IN consulta.nif_funcionario%TYPE,
        p_id_estado_paciente IN consulta.id_estado_paciente%TYPE,
        p_relatorio          IN VARCHAR2);

    -- Procedimento para validar se é permitido registar uma nova consulta a um processo
    FUNCTION validar_nova_consulta(
        p_id_processo      IN consulta.id_processo%TYPE)
    RETURN BOOLEAN;

     -- Função para obter a data da última consulta realizada num processo
    FUNCTION obter_data_ultima_consulta(p_id_processo IN consulta.id_processo%TYPE)
    RETURN DATE DETERMINISTIC;


END et_consulta;
/