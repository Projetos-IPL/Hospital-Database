CREATE OR REPLACE PACKAGE BODY et_tratamento AS

    PROCEDURE registar_tratamento(
        p_nif                IN tratamento.nif%TYPE,
        p_id_area_atuacao    IN tratamento.id_area_atuacao%TYPE
    )
    IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Registar tratamento';
            INSERT INTO tratamento
                (nif, id_area_atuacao)
                VALUES (
                        p_nif,
                        p_id_area_atuacao
                       );
        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.PUT_LINE('Error code: '|| SQLCODE);
                dbms_output.PUT_LINE(SQLERRM);
                ROLLBACK;
    END registar_tratamento;

    PROCEDURE finalizar_tratamento(
        p_id_tratamento IN tratamento.id_tratamento%TYPE
    )
    IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Finalizar registo';
        UPDATE tratamento
            SET dta_alta = SYSDATE
            WHERE id_tratamento = p_id_tratamento;
        COMMIT;
    END finalizar_tratamento;



END et_tratamento;
/