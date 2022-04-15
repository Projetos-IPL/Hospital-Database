CREATE OR REPLACE PACKAGE BODY et_tratamento AS

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
        dbms_output.put_line(v_error_logs);
    END;


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
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END registar_tratamento;


    PROCEDURE registar_primeiro_tratamento(
            p_nif                IN tratamento.nif%TYPE,
            p_id_area_atuacao    IN tratamento.id_area_atuacao%TYPE
        )
    IS
        ex_paciente_ja_tem_tratamento EXCEPTION;
        n_count_trat INT;
    BEGIN
        -- Verificar se o paciente já tem algum tratamento associado
        SELECT COUNT(1) INTO n_count_trat
            FROM tratamento
            WHERE nif = p_nif;

        IF n_count_trat <> 0 THEN
            adicionar_error_log('Paciente com nif:' || p_nif || ' tem pelo menos um tratamento associado.');
            RAISE ex_paciente_ja_tem_tratamento;
        END IF;

        INSERT INTO tratamento
            (nif, id_area_atuacao)
            VALUES (
                    p_nif,
                    p_id_area_atuacao
                   );

        EXCEPTION
            WHEN ex_paciente_ja_tem_tratamento THEN
                print_error_log;
                limpar_error_log;
                exception_handler.handle_user_exception('paciente_ja_tem_tratamento');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END registar_primeiro_tratamento;


    PROCEDURE finalizar_tratamento(
        p_id_tratamento IN tratamento.id_tratamento%TYPE
    )
    IS
        dt_dta_alta DATE;
    BEGIN
        -- Obter data de alta do tratamento
        SELECT dta_alta INTO dt_dta_alta
            FROM tratamento
            WHERE id_tratamento = p_id_tratamento;

        IF dt_dta_alta IS NOT NULL THEN
            RAISE ex_tratamento_ja_finalizado;
        END IF;

        SET TRANSACTION READ WRITE NAME 'Finalizar registo';
        UPDATE tratamento
            SET dta_alta = SYSDATE
            WHERE id_tratamento = p_id_tratamento;
        COMMIT;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                exception_handler.handle_user_exception('tratamento_repetido');
            WHEN ex_tratamento_ja_finalizado THEN
                exception_handler.handle_user_exception('tratamento_ja_finalizado');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END finalizar_tratamento;


    FUNCTION validar_alteracao(
        p_rec_novo_trat     IN tratamento%rowtype,
        p_rec_antigo_trat   IN tratamento%rowtype)
    RETURN BOOLEAN IS
        b_valid BOOLEAN := TRUE;
    BEGIN
        -- SE A DATA DE ALTA JÁ FOI ATRIBUIDA NÃO É PERMITIDO EFETUAR ALTERAÇÕES NO ESTADO DO PACIENTE, ELE ESTÁ BEM.
        IF p_rec_antigo_trat.dta_alta IS NOT NULL THEN
            adicionar_error_log('Tentativa de alteração de tratamento após alta atribuida.');
            b_valid := FALSE;
        END IF;

        --  VERIFICAR SE EXISTE ALTERAÇÕES EM CAMPOS QUE NÃO PODEM SER ALTERADOS.
        -- Alteração PK
        IF p_rec_novo_trat.id_tratamento <> p_rec_antigo_trat.id_tratamento THEN
            adicionar_error_log('Tentativa de alteração do id_tratamento do tratamento.');
            b_valid := FALSE;
        END IF;

        -- Alteração paciente
        IF p_rec_novo_trat.nif <> p_rec_antigo_trat.nif THEN
            adicionar_error_log('Tentativa de alteração do nif do tratamento.');
            b_valid := FALSE;
        END IF;

        -- Alteração da área de atuação
        IF p_rec_novo_trat.id_area_atuacao <> p_rec_antigo_trat.id_area_atuacao THEN
            adicionar_error_log('Tentativa de alteração da área de atuação no tratamento');
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
    PROCEDURE atualizar_estado_tratamento(
        p_id_tratamento tratamento.id_tratamento%TYPE,
        p_id_estado_paciente tratamento.id_estado_paciente%TYPE
    ) IS
    BEGIN
        UPDATE tratamento SET id_estado_paciente = p_id_estado_paciente
            WHERE id_tratamento = p_id_tratamento;

        EXCEPTION
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END atualizar_estado_tratamento;

END et_tratamento;
/