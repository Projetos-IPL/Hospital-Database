-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Corpo do pacote ET_PROCESSO

CREATE OR REPLACE PACKAGE BODY et_processo AS

    -- Esta variável é utilizada para registar erros, por exemplo, alterações inválidas que
    -- são detetadas durante o procedimento de validação de alterações.
    v_error_logs VARCHAR2(3000);


    -- Procedimento para limpar a variável de registo de erros
    PROCEDURE limpar_error_log IS
    BEGIN
        v_error_logs := '';
    END limpar_error_log;


    -- Procedimento para adicionar uma linha ao registo de erros
    PROCEDURE adicionar_error_log(
        p_erro IN VARCHAR2
    ) IS
    BEGIN
        v_error_logs := v_error_logs ||
                        chr(10) ||
                        '['||TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS')||'] '||
                        p_erro;
    END adicionar_error_log;


    FUNCTION obter_error_log
    RETURN VARCHAR2 IS
    BEGIN
        RETURN v_error_logs;
    END;

    -- Procedimento para imprimir o registo de erro
    PROCEDURE print_error_log IS
    BEGIN
        dbms_output.put_line('et_processo error logs');
        dbms_output.put_line(v_error_logs);
    END;


    PROCEDURE registar_processo(
        p_nif                IN processo.nif%TYPE,
        p_id_area_atuacao    IN processo.id_area_atuacao%TYPE
    )
    IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Registar processo';
            INSERT INTO processo
                (nif, id_area_atuacao)
                VALUES (
                        p_nif,
                        p_id_area_atuacao
                       );
        COMMIT;

        EXCEPTION
            WHEN et_processo.ex_processo_repetido THEN
                exception_handler.handle_user_exception('processo_repetido');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END registar_processo;


    -- Como este procedimento é apenas utilizado no procedimento et_pessoa.adicionar_paciente
    -- e não é suposto ser usado individualmente as suas exceções não são tratadas aqui.
    -- O controlo da transação também não é feito aqui pelo mesmo motivo.
    PROCEDURE registar_primeiro_processo(
            p_nif                IN processo.nif%TYPE,
            p_id_area_atuacao    IN processo.id_area_atuacao%TYPE
        )
    IS
        n_count_trat INT;
    BEGIN
        -- Verificar se o paciente já tem algum processo associado
        SELECT COUNT(1) INTO n_count_trat
            FROM processo
            WHERE nif = p_nif;

        IF n_count_trat <> 0 THEN
            adicionar_error_log('Paciente com nif:' || p_nif || ' já tem pelo menos um processo associado.');
            RAISE ex_paciente_ja_tem_processo;
        END IF;

        INSERT INTO processo
            (nif, id_area_atuacao)
            VALUES (
                    p_nif,
                    p_id_area_atuacao
                   );

    END registar_primeiro_processo;


    PROCEDURE finalizar_processo(
        p_id_processo IN processo.id_processo%TYPE
    )
    IS
        dt_dta_alta DATE;
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Finalizar registo';

        -- Obter data de alta do processo
        SELECT dta_alta INTO dt_dta_alta
            FROM processo
            WHERE id_processo = p_id_processo;

        IF dt_dta_alta IS NOT NULL THEN
            RAISE ex_processo_ja_finalizado;
        END IF;


        UPDATE processo
            SET dta_alta = SYSDATE
            WHERE id_processo = p_id_processo;

        COMMIT;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                exception_handler.handle_user_exception('processo_repetido');
            WHEN ex_processo_ja_finalizado THEN
                exception_handler.handle_user_exception('processo_ja_finalizado');
            WHEN et_processo.ex_alteracao_invalida THEN
                exception_handler.handle_user_exception('alteracao_processo_invalida');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END finalizar_processo;


    FUNCTION validar_alteracao(
        p_rec_novo_trat     IN processo%rowtype,
        p_rec_antigo_trat   IN processo%rowtype)
    RETURN BOOLEAN IS
        b_valid BOOLEAN := TRUE;
    BEGIN
        -- SE A DATA DE ALTA JÁ FOI ATRIBUIDA NÃO É PERMITIDO EFETUAR ALTERAÇÕES NO ESTADO DO PACIENTE, ELE ESTÁ BEM.
        IF p_rec_antigo_trat.dta_alta IS NOT NULL THEN
            adicionar_error_log('Tentativa de alteração de processo após alta atribuida.');
            b_valid := FALSE;
        END IF;

        --  VERIFICAR SE EXISTE ALTERAÇÕES EM CAMPOS QUE NÃO PODEM SER ALTERADOS.
        -- Alteração PK
        IF p_rec_novo_trat.id_processo <> p_rec_antigo_trat.id_processo THEN
            adicionar_error_log('Tentativa de alteração do id_processo do processo.');
            b_valid := FALSE;
        END IF;

        -- Alteração paciente
        IF p_rec_novo_trat.nif <> p_rec_antigo_trat.nif THEN
            adicionar_error_log('Tentativa de alteração do nif do processo.');
            b_valid := FALSE;
        END IF;

        -- Alteração da área de atuação
        IF p_rec_novo_trat.id_area_atuacao <> p_rec_antigo_trat.id_area_atuacao THEN
            adicionar_error_log('Tentativa de alteração da área de atuação no processo');
            b_valid := FALSE;
        END IF;

        -- Alteração da data de inicio
        IF p_rec_novo_trat.dta_inicio <> p_rec_antigo_trat.dta_inicio THEN
            adicionar_error_log('Tentativa de alteração da data de ínicio.');
            b_valid := FALSE;
        END IF;

        -- Data de alta antes da data de inicio.
        IF p_rec_novo_trat.dta_alta IS NOT NULL AND p_rec_novo_trat.dta_alta < p_rec_novo_trat.dta_inicio THEN
            adicionar_error_log('Tentativa de atribuição de uma data de alta menor do que a data de ínicio.');
            b_valid := FALSE;
        END IF;

        RETURN b_valid;
    END validar_alteracao;

    -- Procedimento para atualizar o estado de um paciente
    PROCEDURE atualizar_estado_processo(
        p_id_processo processo.id_processo%TYPE,
        p_id_estado_paciente processo.id_estado_paciente%TYPE
    ) IS
    BEGIN
        UPDATE processo SET id_estado_paciente = p_id_estado_paciente
            WHERE id_processo = p_id_processo;
    END atualizar_estado_processo;

    PROCEDURE validar_novo_processo(p_rec_processo IN processo%rowtype)
    IS
        CURSOR cur_processos_ativos IS
            SELECT *
            FROM processo
            WHERE nif = p_rec_processo.nif
              AND dta_alta IS NULL
        ;
    BEGIN
        -- Procurar registos ativos do paciente e lançar exceção se encontrar um
        -- processo para a mesma área de atuação do novo processo.
        FOR rec_processo IN cur_processos_ativos
            LOOP
                IF p_rec_processo.id_area_atuacao = rec_processo.id_area_atuacao THEN
                    RAISE et_processo.ex_processo_repetido;
                END IF;
            END LOOP;
    END;

END et_processo;
/