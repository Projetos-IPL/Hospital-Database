CREATE OR REPLACE PACKAGE et_relatorio AS

    -- Função para adicionar um relatório, devolvendo o ID criado
    FUNCTION adicionar_relatorio(
        p_nif       IN relatorio.nif%TYPE,
        p_texto     IN relatorio.texto%TYPE,
        p_categoria IN relatorio.categoria%TYPE)
    RETURN INT;

END et_relatorio;
/