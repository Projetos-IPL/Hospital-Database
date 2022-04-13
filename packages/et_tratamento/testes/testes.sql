-- Testar validação tratamento
DECLARE
    rec_antigo tratamento%rowtype;
    rec_novo tratamento%rowtype;
BEGIN
    rec_antigo.id_tratamento := 1;
    rec_antigo.dta_inicio := TO_DATE('10-04-2022', 'DD-MM-YYYY');
    rec_antigo.nif := 123456111;
    rec_antigo.id_area_atuacao := 1;
    rec_antigo.dta_alta := NULL;

    rec_novo.id_tratamento := 1;
    rec_novo.dta_inicio := TO_DATE('10-04-2022', 'DD-MM-YYYY');
    rec_novo.nif := 123456111;
    rec_novo.id_area_atuacao := 1;
    rec_novo.dta_alta := TO_DATE('11-04-2022', 'DD-MM-YYYY');

    dbms_output.PUT_LINE(TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS'));

    IF et_tratamento.validar_alteracao(rec_novo, rec_antigo) THEN
        dbms_output.PUT_LINE('Válido');
    ELSE
        et_tratamento.print_error_log;

    END IF;
END;

SELECT dbtimezone from dual;


