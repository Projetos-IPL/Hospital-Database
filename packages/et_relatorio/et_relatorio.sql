-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Cabeçalho do pacote ET_CIRURGIA

CREATE OR REPLACE PACKAGE et_relatorio AS

    ex_alteracao_relatorio EXCEPTION;

    -- Função para adicionar um relatório, devolvendo o ID criado
    FUNCTION adicionar_relatorio(
        p_nif       IN relatorio.nif%TYPE,
        p_texto     IN relatorio.texto%TYPE,
        p_categoria IN relatorio.categoria%TYPE)
    RETURN INT;

END et_relatorio;
/