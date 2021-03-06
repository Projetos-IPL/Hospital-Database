-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Corpo do pacote ET_RELATORIO


CREATE OR REPLACE PACKAGE BODY et_relatorio AS

    FUNCTION adicionar_relatorio(
        p_nif       IN relatorio.nif%TYPE,
        p_texto     IN relatorio.texto%TYPE,
        p_categoria IN relatorio.categoria%TYPE)
    RETURN INT
    IS
        n_id_relatorio INT;
    BEGIN
        INSERT INTO relatorio (nif, texto, categoria)
            VALUES (p_nif, p_texto, p_categoria)
            RETURNING id_relatorio INTO n_id_relatorio;

        RETURN n_id_relatorio;

    END adicionar_relatorio;

END et_relatorio;
/