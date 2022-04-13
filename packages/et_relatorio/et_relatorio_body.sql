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
                
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.PUT_LINE(utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)));
                dbms_output.PUT_LINE(SQLERRM);
    END adicionar_relatorio;
    
END et_relatorio;
/