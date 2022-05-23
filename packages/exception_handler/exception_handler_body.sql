-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Corpo do pacote EXCEPTION_HANDLER

CREATE OR REPLACE PACKAGE BODY exception_handler AS

    -- Esta variável serve para contar o número de ciclos recursivos para impedir ciclos infinitos
    n_recursive_loop_count INTEGER := 0;

    -- Função para obter stacktrace
    FUNCTION get_stack_trace
    RETURN VARCHAR2 IS
        v_stacktrace VARCHAR2(500);
    BEGIN
        -- Começa no 2 para não colocar o get_stack_trace
        FOR j IN REVERSE 2..UTL_Call_Stack.Dynamic_Depth() LOOP
          v_stacktrace := v_stacktrace || UTL_Call_Stack.Concatenate_Subprogram(UTL_Call_Stack.Subprogram(j)) || ', ';
        END LOOP;

		-- Remover os dois últimos caracteres da string
        v_stacktrace := SUBSTR(v_stacktrace, 0, LENGTH(v_stacktrace) - 2);

        RETURN v_stacktrace;
    END get_stack_trace;

    -- Procedimento para adicionar uma exceção ao histórico
    PROCEDURE log_exception(
        p_code       IN INT,
        p_stacktrace IN VARCHAR2,
        p_errm       IN VARCHAR2
        )
    IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Log Exception';
        
        INSERT INTO exception_log (code, logged_at, errm, stacktrace)
            VALUES (p_code, CURRENT_TIMESTAMP, p_errm, p_stacktrace);
        
        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line(UTL_Call_Stack.Concatenate_Subprogram(UTL_Call_Stack.Subprogram(1)));
                dbms_output.put_line(sqlerrm);
                ROLLBACK;
    END log_exception;
    

    PROCEDURE add_user_exception (
        p_code IN user_exception.code%TYPE,
        p_name IN user_exception.name%TYPE,
        p_errm IN user_exception.errm%TYPE)
    IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Add User Exception';

        IF p_code NOT BETWEEN -20999 AND -20000 THEN
            RAISE exception_code_out_of_bounds;
        END IF;

        INSERT INTO user_exception
            VALUES (p_code, p_name, p_errm);

        COMMIT;

        EXCEPTION
            WHEN exception_code_out_of_bounds THEN
                handle_user_exception('exception_code_out_of_bounds');
            WHEN exception_handler.ex_mal_formatada THEN
                exception_handler.handle_user_exception('excecao_mal_formatada');
            WHEN OTHERS THEN
                handle_sys_exception(SQLCODE, SQLERRM);
    END add_user_exception;


    -- Procedimento para tratar uma exceção definida por nós
    PROCEDURE handle_user_exception(p_name IN user_exception.name%TYPE)
    IS
        n_code user_exception.code%TYPE;
        v_errm user_exception.errm%TYPE;
    BEGIN
        ROLLBACK;

        -- Verificar se o handle_user_exception entrou em um ciclo recursivo infinito, apenas
        -- acontece quando a exceção 'exception_not_defined' não existe na tabela user_exception
        IF n_recursive_loop_count > 1 THEN
            dbms_output.put_line('Erro no handle_user_exception, as exceções internas não estão definidas.');
            RETURN;
        END IF;


        -- Fazer log da exceção
        SELECT code, errm
            INTO n_code, v_errm
            FROM user_exception
            WHERE name = UPPER(p_name);

        -- Limpar contador de ciclos recursivos
        n_recursive_loop_count := 0;

        log_exception(n_code, get_stack_trace(), v_errm);

        RAISE_APPLICATION_ERROR(
            n_code,
            v_errm
        );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Incrementar contador de ciclos recursivos porque é feita uma chamada recursiva.
                n_recursive_loop_count := n_recursive_loop_count + 1;
                dbms_output.put_line(p_name);
                handle_user_exception('exception_not_defined');
    END handle_user_exception;


    -- Procedimento para tratar uma exceção do sistema
    PROCEDURE handle_sys_exception(
        p_code IN INT,
        p_errm IN VARCHAR2)
    IS
        v_stacktrace VARCHAR2(500) := get_stack_trace();
    BEGIN
        ROLLBACK;
        dbms_output.PUT_LINE(v_stacktrace);
        dbms_output.PUT_LINE(p_errm);
        log_exception(p_code, v_stacktrace, p_errm);
        handle_user_exception('system_exception');
    END handle_sys_exception;

END exception_handler;
/
