CREATE OR REPLACE TRIGGER tbi_area_atuacao
    BEFORE
        INSERT
    ON area_atuacao
    FOR EACH ROW
BEGIN
    :new.id_area_atuacao := pk_area_atuacao_seq.nextval;
END;
/


CREATE OR REPLACE TRIGGER tbi_cirurgia
    BEFORE
        INSERT
    ON cirurgia
    FOR EACH ROW
BEGIN
    :new.id_cirurgia := pk_cirurgia_seq.nextval;
END;
/


CREATE OR REPLACE TRIGGER tbi_consulta
    BEFORE
        INSERT
    ON consulta
    FOR EACH ROW
BEGIN
    :new.id_consulta := pk_consulta_seq.nextval;
    :new.dta_realizacao := SYSDATE;
END;
/


CREATE OR REPLACE TRIGGER tbi_relatorio
    BEFORE
        INSERT
    ON relatorio
    FOR EACH ROW
BEGIN
    :new.id_relatorio := pk_relatorio_seq.nextval;
END;
/


CREATE OR REPLACE TRIGGER tbi_tipo_cirurgia
    BEFORE
        INSERT
    ON tipo_cirurgia
    FOR EACH ROW
BEGIN
    :new.id_tipo_cirurgia := pk_tipo_cirurgia_seq.nextval;
END;
/


CREATE OR REPLACE TRIGGER tbi_tratamento
    BEFORE
        INSERT
    ON tratamento
    FOR EACH ROW
DECLARE
    CURSOR cur_tratamentos_ativos IS
        SELECT *
        FROM tratamento
        WHERE nif = :new.nif
          AND dta_alta IS NULL
    ;
    rec_tratamento tratamento%ROWTYPE;
BEGIN
    :new.id_tratamento := pk_tratamento_seq.nextval;
    :new.dta_inicio := SYSDATE;

    /*
        Procurar registos ativos do paciente e lançar exceção se encontrar um
        tratamento para a mesma área de atuação do novo tratamento.
     */
    FOR rec_tratamento IN cur_tratamentos_ativos
        LOOP
            IF :new.id_area_atuacao = rec_tratamento.id_area_atuacao THEN
                RAISE et_tratamento.ex_tratamento_repetido;
            END IF;
        END LOOP;

EXCEPTION
    WHEN et_tratamento.ex_tratamento_repetido THEN
        RAISE_APPLICATION_ERROR(
                et_tratamento.ex_tratamento_repetido_error_code,
                et_tratamento.ex_tratamento_repetido_errm || :new.nif
            );
    WHEN OTHERS THEN
        dbms_output.PUT_LINE(sqlerrm);

END tbi_tratamento;
/


CREATE OR REPLACE TRIGGER tbu_tratamento
    BEFORE UPDATE
    ON tratamento
    FOR EACH ROW
DECLARE
    b_alteracao_valida BOOLEAN;
    rec_novo_trat      tratamento%ROWTYPE;
    rec_antigo_trat    tratamento%ROWTYPE;
BEGIN
    -- Passar dados do new e old para as variáveis
    rec_novo_trat.id_tratamento := :new.id_tratamento;
    rec_novo_trat.nif := :new.nif;
    rec_novo_trat.id_area_atuacao := :new.id_area_atuacao;
    rec_novo_trat.id_estado_paciente := :new.id_estado_paciente;
    rec_novo_trat.dta_inicio := :new.dta_inicio;
    rec_novo_trat.dta_alta := :new.dta_alta;

    rec_antigo_trat.id_tratamento := :old.id_tratamento;
    rec_antigo_trat.nif := :old.nif;
    rec_antigo_trat.id_area_atuacao := :old.id_area_atuacao;
    rec_antigo_trat.id_estado_paciente := :old.id_estado_paciente;
    rec_antigo_trat.dta_inicio := :old.dta_inicio;
    rec_antigo_trat.dta_alta := :old.dta_alta;

    -- Validar alterações
    b_alteracao_valida := et_tratamento.validar_alteracao(rec_novo_trat, rec_antigo_trat);

    -- Se as validações forem inválidas lançar exceção.
    IF b_alteracao_valida = FALSE THEN
        RAISE et_tratamento.ex_alteracao_invalida;
    END IF;

EXCEPTION
    WHEN et_tratamento.ex_alteracao_invalida THEN
        RAISE_APPLICATION_ERROR(
                et_tratamento.ex_alteracao_invalida_error_code,
                et_tratamento.ex_alteracao_invalida_errm ||
                CHR(10) ||
                et_tratamento.obter_error_log
            );
        et_tratamento.limpar_error_log;
END tbu_tratamento;
/


CREATE OR REPLACE TRIGGER tbi_pessoa
    BEFORE
        INSERT
    ON pessoa
    FOR EACH ROW
DECLARE
    n_idade NUMBER;
BEGIN
    n_idade := MONTHS_BETWEEN(SYSDATE, :new.dta_nasc) / 12;

    IF n_idade < 18 THEN
        RAISE et_pessoa.ex_menor_de_idade;
    END IF;

EXCEPTION
    WHEN et_pessoa.ex_menor_de_idade THEN
        RAISE_APPLICATION_ERROR(
                et_pessoa.ex_menor_de_idade_error_code,
                et_pessoa.ex_menor_de_idade_errm
            );
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
                        SQLCODE,
                        SQLERRM
            );
END tbi_pessoa;
/


CREATE OR REPLACE TRIGGER tai_paciente
    AFTER INSERT ON paciente
    FOR EACH ROW
DECLARE
    n_nif_paciente paciente.nif%TYPE;
BEGIN
    -- Verificar se paciente tem tratamento associado
    SELECT nif INTO n_nif_paciente
        FROM tratamento
        WHERE nif = :NEW.nif;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                et_pessoa.ex_paciente_sem_tratamento_error_code,
                et_pessoa.ex_paciente_sem_tratamento_errm
                );
END tai_paciente;
/


CREATE OR REPLACE TRIGGER tbud_relatorio
    BEFORE
        UPDATE OR DELETE
    ON relatorio
    FOR EACH ROW
BEGIN
    RAISE et_relatorio.alteracao_relatorio;
END tbud_relatorio;
/


CREATE OR REPLACE TRIGGER tbud_consulta
    BEFORE
        UPDATE OR DELETE
    ON consulta
    FOR EACH ROW
BEGIN
    RAISE et_consulta.ex_alteracao_consulta;

    EXCEPTION
        WHEN et_consulta.ex_alteracao_consulta THEN
            RAISE_APPLICATION_ERROR(
                et_consulta.ex_alteracao_consulta_error_code,
                et_consulta.ex_alteracao_consulta_errm
                );
END tbud_consulta;
/


COMMIT;