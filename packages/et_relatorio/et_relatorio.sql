CREATE OR REPLACE PACKAGE et_relatorio AS

    ex_alteracao_relatorio EXCEPTION;
    ex_alteracao_relatorio_error_code INT := -20699;
    ex_alteracao_relatorio_errm VARCHAR2(100) := 'Tentativa de alteração de um relatório';

    -- Função para adicionar um relatório, devolvendo o ID criado
    FUNCTION adicionar_relatorio(
        p_nif       IN relatorio.nif%TYPE,
        p_texto     IN relatorio.texto%TYPE,
        p_categoria IN relatorio.categoria%TYPE)
    RETURN INT;

END et_relatorio;
/