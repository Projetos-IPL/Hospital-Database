
-- Tabela area_atuacao
CREATE OR REPLACE TRIGGER tbi_area_atuacao
    BEFORE INSERT ON area_atuacao
    FOR EACH ROW
BEGIN
    IF :NEW.id_area_atuacao IS NULL THEN
        :NEW.id_area_atuacao := pk_area_atuacao_seq.nextval;
    END IF;
END tbi_area_atuacao;
/

-- Tabela tipo_cirurgia

CREATE OR REPLACE TRIGGER tbi_tipo_cirurgia
    BEFORE INSERT ON tipo_cirurgia
    FOR EACH ROW
BEGIN
    IF :NEW.id_tipo_cirurgia IS NULL THEN
        :NEW.id_tipo_cirurgia := pk_tipo_cirurgia_seq.nextval;
    END IF;
END tbi_tipo_cirurgia;
/

-- Tabela estado paciente

CREATE OR REPLACE TRIGGER tbi_estado_paciente
    BEFORE INSERT ON estado_paciente
    FOR EACH ROW
BEGIN
    IF :NEW.id_estado_paciente IS NULL THEN
        :NEW.id_estado_paciente := pk_estado_paciente_seq.nextval;
    END IF;
END tbi_estado_paciente;
/

-- Tabela pessoa

CREATE OR REPLACE TRIGGER tbi_pessoa
    BEFORE INSERT ON pessoa
    FOR EACH ROW
DECLARE
    rec_pessoa pessoa%ROWTYPE;
BEGIN
    rec_pessoa.nif := :NEW.nif;
    rec_pessoa.prim_nome := :NEW.prim_nome;
    rec_pessoa.ult_nome := :NEW.ult_nome;
    rec_pessoa.morada := :NEW.morada;
    rec_pessoa.dta_nasc := :NEW.dta_nasc;
    et_pessoa.validar_pessoa(rec_pessoa);
END tbi_pessoa;
/

CREATE OR REPLACE TRIGGER tbu_pessoa
    BEFORE UPDATE ON pessoa
    FOR EACH ROW
DECLARE
    rec_pessoa pessoa%ROWTYPE;
    rec_pessoa_old pessoa%ROWTYPE;
BEGIN
    rec_pessoa.nif := :NEW.nif;
    rec_pessoa.prim_nome := :NEW.prim_nome;
    rec_pessoa.ult_nome := :NEW.ult_nome;
    rec_pessoa.morada := :NEW.morada;
    rec_pessoa.dta_nasc := :NEW.dta_nasc;

    rec_pessoa_old.nif := :OLD.nif;
    rec_pessoa_old.prim_nome := :OLD.prim_nome;
    rec_pessoa_old.ult_nome := :OLD.ult_nome;
    rec_pessoa_old.morada := :OLD.morada;
    rec_pessoa_old.dta_nasc := :OLD.dta_nasc;

    et_pessoa.validar_alteracao_pessoa(rec_pessoa, rec_pessoa_old);
END;
/

-- Tabela paciente

CREATE OR REPLACE TRIGGER tai_paciente
    AFTER INSERT ON paciente
    FOR EACH ROW
DECLARE
    rec_paciente paciente%ROWTYPE;
BEGIN
    rec_paciente.nif := :NEW.nif;
    rec_paciente.n_utente_saude := :NEW.n_utente_saude;
    et_pessoa.validar_novo_paciente(rec_paciente);
END tai_paciente;
/

CREATE OR REPLACE TRIGGER tbud_paciente
    BEFORE DELETE OR UPDATE ON paciente
    FOR EACH ROW
DECLARE
BEGIN
    RAISE et_pessoa.ex_alteracao_invalida;
END;

-- Tabela processo

CREATE OR REPLACE TRIGGER tbi_processo
    BEFORE INSERT ON processo
    FOR EACH ROW
DECLARE
    rec_processo processo%rowtype;
BEGIN
    IF :NEW.id_processo IS NULL THEN
        :NEW.id_processo := pk_processo_seq.nextval;
    END IF;

    :NEW.dta_inicio := SYSDATE;

    rec_processo.nif := :NEW.nif;
    rec_processo.dta_alta := :NEW.dta_alta;
    rec_processo.id_area_atuacao := :NEW.id_area_atuacao;
    rec_processo.id_estado_paciente := :NEW.id_estado_paciente;
    rec_processo.dta_inicio := :NEW.dta_inicio;
    rec_processo.id_processo := :NEW.id_processo;

    et_processo.validar_novo_processo(rec_processo);

END tbi_processo;
/

CREATE OR REPLACE TRIGGER tbu_processo
    BEFORE UPDATE ON processo
    FOR EACH ROW
DECLARE
    b_alteracao_valida BOOLEAN;
    rec_novo_trat      processo%ROWTYPE;
    rec_antigo_trat    processo%ROWTYPE;
BEGIN
    -- Passar dados do new e old para as variáveis
    rec_novo_trat.id_processo := :new.id_processo;
    rec_novo_trat.nif := :new.nif;
    rec_novo_trat.id_area_atuacao := :new.id_area_atuacao;
    rec_novo_trat.id_estado_paciente := :new.id_estado_paciente;
    rec_novo_trat.dta_inicio := :new.dta_inicio;
    rec_novo_trat.dta_alta := :new.dta_alta;

    rec_antigo_trat.id_processo := :old.id_processo;
    rec_antigo_trat.nif := :old.nif;
    rec_antigo_trat.id_area_atuacao := :old.id_area_atuacao;
    rec_antigo_trat.id_estado_paciente := :old.id_estado_paciente;
    rec_antigo_trat.dta_inicio := :old.dta_inicio;
    rec_antigo_trat.dta_alta := :old.dta_alta;

    -- Validar alterações
    b_alteracao_valida := et_processo.validar_alteracao(rec_novo_trat, rec_antigo_trat);

    -- Se as validações forem inválidas lançar exceção.
    IF b_alteracao_valida = FALSE THEN
        et_processo.print_error_log();
        RAISE et_processo.ex_alteracao_invalida;
    END IF;

END tbu_processo;
/


-- Tabela consulta

CREATE OR REPLACE TRIGGER tbi_consulta
    BEFORE INSERT ON consulta
    FOR EACH ROW
BEGIN
    IF :NEW.id_consulta IS NULL THEN
        :NEW.id_consulta := pk_consulta_seq.nextval;
    END IF;

    :NEW.dta_realizacao := SYSDATE;

    IF NOT et_consulta.validar_nova_consulta(:NEW.id_processo) THEN
        RAISE et_consulta.ex_consulta_em_processo_finalizado;
    END IF;

END tbi_consulta;
/

CREATE OR REPLACE TRIGGER tbud_consulta
    BEFORE UPDATE OR DELETE ON consulta
    FOR EACH ROW
BEGIN
    -- Como não é permitido atualizar ou apagar consultas, lançar exceção
    RAISE et_consulta.ex_alteracao_consulta;

END tbud_consulta;
/

CREATE OR REPLACE TRIGGER tai_consulta
    AFTER INSERT ON consulta
    FOR EACH ROW
BEGIN
    -- O estado do processo é atualizado quando uma consulta é adicionada
    et_processo.atualizar_estado_processo(:NEW.id_processo, :NEW.id_estado_paciente);
END tai_consulta;
/

-- Tabela cirurgia

CREATE OR REPLACE TRIGGER tbi_cirurgia
    BEFORE INSERT ON cirurgia
    FOR EACH ROW
DECLARE
    n_id_area_atuacao_tipo_cirugia INTEGER;
    n_id_area_atuacao_processo INTEGER;
    dt_dta_alta DATE;
BEGIN
    IF :NEW.id_cirurgia IS NULL THEN
        :NEW.id_cirurgia := pk_cirurgia_seq.nextval;
    END IF;

    :NEW.dta_realizacao := SYSDATE;

        -- Verificar se o processo ainda está ativa
    SELECT dta_alta INTO dt_dta_alta
        FROM processo
        WHERE id_processo = :NEW.id_processo;

    IF dt_dta_alta IS NOT NULL THEN
        RAISE et_cirurgia.ex_cirurgia_em_processo_finalizado;
    END IF;

    -- Verificar se cirurgia é da área de atuação do processo e lançar exceção se não for.
    SELECT id_area_atuacao INTO n_id_area_atuacao_processo
        FROM processo
        WHERE id_processo = :NEW.id_processo;

    SELECT id_area_atuacao INTO n_id_area_atuacao_tipo_cirugia
        FROM tipo_cirurgia
        WHERE id_tipo_cirurgia = :NEW.id_tipo_cirurgia;

    IF n_id_area_atuacao_processo <> n_id_area_atuacao_tipo_cirugia THEN
        RAISE et_cirurgia.ex_area_atuacao_nao_corresponde;
    END IF;

END tbi_cirurgia;
/

CREATE OR REPLACE TRIGGER tbud_cirurgia
    BEFORE UPDATE OR DELETE ON cirurgia
    FOR EACH ROW
BEGIN
    -- Como não é permitido atualizar ou apagar uma cirurgia, lançar exceção
    RAISE et_cirurgia.ex_alteracao_cirurgia;
END tbud_cirurgia;
/

-- Tabela relatorio

CREATE OR REPLACE TRIGGER tbi_relatorio
    BEFORE INSERT ON relatorio
    FOR EACH ROW
BEGIN
    IF :NEW.id_relatorio IS NULL THEN
        :NEW.id_relatorio := pk_relatorio_seq.nextval;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER tbud_relatorio
    BEFORE UPDATE OR DELETE ON relatorio
    FOR EACH ROW
BEGIN
    -- Como não é permitido atualizar ou apagar relatório, lançar exceção
    RAISE et_relatorio.ex_alteracao_relatorio;
END tbud_relatorio;
/


-- Tabela user_exception

CREATE OR REPLACE TRIGGER tbi_user_exception
    BEFORE INSERT ON user_exception
    FOR EACH ROW
BEGIN
    -- verifica se o código da exceção se encontra no intervalo correto
    IF :NEW.code NOT BETWEEN -20999 AND -20000 THEN
        RAISE exception_handler.exception_code_out_of_bounds;
    END IF;

    -- verifica se o nome da exceção não contém espaços
    IF INSTR(:NEW.name, ' ') <> 0 THEN
        RAISE exception_handler.ex_mal_formatada;
    END IF;

    -- converter para upper case
    :NEW.name := UPPER(:NEW.name);

END tbi_user_exception;
/


-- Tabela exception log

CREATE OR REPLACE TRIGGER tbi_exception_log
    BEFORE INSERT ON exception_log
    FOR EACH ROW
BEGIN
    :NEW.id_exception_log := pk_exception_log_seq.nextval;
END tbi_exception_log;
/


COMMIT;