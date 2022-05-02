
-- Tabela area_atuacao

CREATE OR REPLACE TRIGGER tbi_area_atuacao
    BEFORE INSERT ON area_atuacao
    FOR EACH ROW
BEGIN
    :new.id_area_atuacao := pk_area_atuacao_seq.nextval;
END tbi_area_atuacao;
/

-- Tabela tipo_cirurgia

CREATE OR REPLACE TRIGGER tbi_tipo_cirurgia
    BEFORE INSERT ON tipo_cirurgia
    FOR EACH ROW
BEGIN
    :new.id_tipo_cirurgia := pk_tipo_cirurgia_seq.nextval;
END tbi_tipo_cirurgia;
/

-- Tabela estado paciente

CREATE OR REPLACE TRIGGER tbi_estado_paciente
    BEFORE INSERT ON estado_paciente
    FOR EACH ROW
BEGIN
    :NEW.id_estado_paciente := pk_estado_paciente_seq.nextval;
END tbi_estado_paciente;
/

-- Tabela pessoa

CREATE OR REPLACE TRIGGER tbi_pessoa
    BEFORE INSERT ON pessoa
    FOR EACH ROW
DECLARE
    n_idade NUMBER;
BEGIN
    -- Validar idade
    n_idade := MONTHS_BETWEEN(SYSDATE, :NEW.dta_nasc) / 12;

    IF n_idade < 18 THEN
        RAISE et_pessoa.ex_menor_de_idade;
    END IF;

    -- Validar nome da pessoa, não pode conter números ou carateres especiais.
    IF et_pessoa.validar_nome(:NEW.prim_nome || :NEW.ult_nome) THEN
        RAISE et_pessoa.ex_nome_invalido;
    END IF;

END tbi_pessoa;
/


-- Tabela paciente

CREATE OR REPLACE TRIGGER tai_paciente
    AFTER INSERT ON paciente
    FOR EACH ROW
DECLARE
    n_count_paciente INTEGER;
BEGIN
    -- Verificar se paciente tem processo associado
    SELECT COUNT(nif) INTO n_count_paciente
        FROM processo
        WHERE nif = :NEW.nif;

    IF n_count_paciente = 0 THEN
        RAISE et_pessoa.ex_paciente_sem_processo;
    END IF;

END tai_paciente;
/


-- Tabela processo

CREATE OR REPLACE TRIGGER tbi_processo
    BEFORE INSERT ON processo
    FOR EACH ROW
DECLARE
    CURSOR cur_processos_ativos IS
        SELECT *
        FROM processo
        WHERE nif = :new.nif
          AND dta_alta IS NULL
    ;
    rec_processo processo%ROWTYPE;
BEGIN
    :new.id_processo := pk_processo_seq.nextval;
    :new.dta_inicio := SYSDATE;

    -- Procurar registos ativos do paciente e lançar exceção se encontrar um
    -- processo para a mesma área de atuação do novo processo.
    FOR rec_processo IN cur_processos_ativos
        LOOP
            IF :new.id_area_atuacao = rec_processo.id_area_atuacao THEN
                RAISE et_processo.ex_processo_repetido;
            END IF;
        END LOOP;

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
    :NEW.id_consulta := pk_consulta_seq.nextval;
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
    :new.id_cirurgia := pk_cirurgia_seq.nextval;
    :new.dta_realizacao := SYSDATE;

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
    :NEW.id_relatorio := pk_relatorio_seq.nextval;
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
    :new.id_exception_log := pk_exception_log_seq.nextval;
END tbi_exception_log;
/


COMMIT;