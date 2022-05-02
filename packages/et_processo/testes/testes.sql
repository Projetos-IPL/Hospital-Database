-- Testar validação processo
DECLARE
    rec_antigo processo%rowtype;
    rec_novo processo%rowtype;
BEGIN
    rec_antigo.id_processo := 1;
    rec_antigo.dta_inicio := TO_DATE('10-04-2022', 'DD-MM-YYYY');
    rec_antigo.nif := 123456111;
    rec_antigo.id_area_atuacao := 1;
    rec_antigo.dta_alta := NULL;

    rec_novo.id_processo := 2;
    rec_novo.dta_inicio := TO_DATE('11-04-2022', 'DD-MM-YYYY');
    rec_novo.nif := 123456112;
    rec_novo.id_area_atuacao := 2;
    rec_novo.dta_alta := TO_DATE('09-04-2022', 'DD-MM-YYYY');

    IF et_processo.validar_alteracao(rec_novo, rec_antigo) THEN
        dbms_output.PUT_LINE('Válido');
    ELSE
        et_processo.print_error_log;
        et_processo.limpar_error_log;

    END IF;
END;

SELECT dbtimezone from dual;


