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
    BEFORE INSERT ON cirurgia
    FOR EACH ROW
DECLARE
    n_id_area_atuacao_tipo_cirugia INTEGER;
    n_id_area_atuacao_tratamento INTEGER;
BEGIN
    :new.id_cirurgia := pk_cirurgia_seq.nextval;
    :new.dta_realizacao := SYSDATE;

    SELECT id_area_atuacao INTO n_id_area_atuacao_tratamento
        FROM tratamento
        WHERE id_tratamento = :NEW.id_tratamento;

    SELECT id_area_atuacao INTO n_id_area_atuacao_tipo_cirugia
        FROM tipo_cirurgia
        WHERE id_tipo_cirurgia = :NEW.id_tipo_cirurgia;

    IF n_id_area_atuacao_tratamento <> n_id_area_atuacao_tipo_cirugia THEN
        RAISE et_cirurgia.ex_area_atuacao_nao_corresponde;
    END IF;

    EXCEPTION
        WHEN et_cirurgia.ex_area_atuacao_nao_corresponde THEN
            exception_handler.handle_user_exception('area_atuacao_nao_corresponde');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
END;
/


CREATE OR REPLACE TRIGGER tbi_exception_log
    BEFORE
        INSERT
    ON exception_log
    FOR EACH ROW
BEGIN
    :new.id_exception_log := pk_exception_log_seq.nextval;
END;
/


CREATE OR REPLACE TRIGGER tbi_consulta
    BEFORE
        INSERT
    ON consulta
    FOR EACH ROW
BEGIN
    :NEW.id_consulta := pk_consulta_seq.nextval;
    :NEW.dta_realizacao := SYSDATE;

    IF et_consulta.validar_nova_consulta(:NEW.id_tratamento) = FALSE THEN
        RAISE et_consulta.ex_consulta_em_tratamento_finalizado;
    END IF;

    EXCEPTION
        WHEN et_consulta.ex_consulta_em_tratamento_finalizado THEN
            exception_handler.handle_user_exception('consulta_em_tratamento_finalizado');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
END;
/


CREATE OR REPLACE TRIGGER tbi_relatorio
    BEFORE
        INSERT
    ON relatorio
    FOR EACH ROW
BEGIN
    :NEW.id_relatorio := pk_relatorio_seq.nextval;
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
        exception_handler.handle_user_exception('tratamento_repetido');
    WHEN OTHERS THEN
        exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
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
        et_tratamento.print_error_log();
        RAISE et_tratamento.ex_alteracao_invalida;
    END IF;

EXCEPTION
    WHEN et_tratamento.ex_alteracao_invalida THEN
        exception_handler.handle_user_exception('alteracao_invalida');
    WHEN OTHERS THEN
        exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
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
    -- Validar idade
    n_idade := MONTHS_BETWEEN(SYSDATE, :new.dta_nasc) / 12;

    IF n_idade < 18 THEN
        RAISE et_pessoa.ex_menor_de_idade;
    END IF;

EXCEPTION
    WHEN et_pessoa.ex_menor_de_idade THEN
        exception_handler.handle_user_exception('menor_de_idade');
    WHEN OTHERS THEN
        exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
END tbi_pessoa;
/


CREATE OR REPLACE TRIGGER tai_paciente
    AFTER INSERT ON paciente
    FOR EACH ROW
DECLARE
    n_count_paciente INTEGER;
BEGIN
    -- Verificar se paciente tem tratamento associado
    SELECT COUNT(nif) INTO n_count_paciente
        FROM tratamento
        WHERE nif = :NEW.nif;
        
    IF n_count_paciente = 0 THEN
        RAISE et_pessoa.ex_paciente_sem_tratamento;
    END IF;

    EXCEPTION
        WHEN et_pessoa.ex_paciente_sem_tratamento THEN
            exception_handler.handle_user_exception('paciente_sem_tratamento');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
END tai_paciente;
/


CREATE OR REPLACE TRIGGER tbud_relatorio
    BEFORE UPDATE OR DELETE
    ON relatorio
    FOR EACH ROW
BEGIN
    -- Como não é permitido atualizar ou apagar relatório, lançar exceção
    RAISE et_relatorio.ex_alteracao_relatorio;

    EXCEPTION
        WHEN et_relatorio.ex_alteracao_relatorio THEN
            exception_handler.handle_user_exception('alteracao_relatorio');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
END tbud_relatorio;
/


CREATE OR REPLACE TRIGGER tbud_cirurgia
    BEFORE UPDATE OR DELETE ON cirurgia
    FOR EACH ROW
BEGIN
    -- Como não é permitido atualizar ou apagar uma cirurgia, lançar exceção
    RAISE et_cirurgia.ex_alteracao_cirurgia;

    EXCEPTION
        WHEN et_cirurgia.ex_alteracao_cirurgia THEN
            exception_handler.handle_user_exception('alteracao_cirurgia');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
END tbud_cirurgia;
/


CREATE OR REPLACE TRIGGER tbud_consulta
    BEFORE UPDATE OR DELETE
    ON consulta
    FOR EACH ROW
BEGIN
    -- Como não é permitido atualizar ou apagar consultas, lançar exceção
    RAISE et_consulta.ex_alteracao_consulta;

    EXCEPTION
        WHEN et_consulta.ex_alteracao_consulta THEN
            exception_handler.handle_user_exception('alteracao_consulta');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
END tbud_consulta;
/


CREATE OR REPLACE TRIGGER tai_consulta
    AFTER INSERT ON consulta
    FOR EACH ROW
BEGIN
    -- O estado do tratamento é atualizado quando uma consulta é adicionada
    et_tratamento.atualizar_estado_tratamento(:NEW.id_tratamento, :NEW.id_estado_paciente);
END;
/


CREATE OR REPLACE TRIGGER tbi_user_exception
    BEFORE INSERT ON user_exception
    FOR EACH ROW
BEGIN
    -- verifica se o código da exceção não contém espaços
    IF INSTR(:NEW.code, ' ') <> 0 THEN
        RAISE exception_handler.ex_mal_formatada;
    END IF;
    
    -- verifica se o nome da exceção não contém espaços
    IF INSTR(:NEW.name, ' ') <> 0 THEN
        RAISE exception_handler.ex_mal_formatada;
    END IF;
    
    -- converter para upper case
    :NEW.name := UPPER(:NEW.name);
    
    EXCEPTION
        WHEN exception_handler.ex_mal_formatada THEN
            exception_handler.handle_user_exception('excecao_mal_formatada');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
END;
/


COMMIT;