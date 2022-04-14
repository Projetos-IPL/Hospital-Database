CREATE OR REPLACE PACKAGE BODY exception_handler AS

    -- Procedimento para adicionar uma exceção ao histórico
    PROCEDURE log_exception(
        p_code IN INT,
        p_stacktrace IN VARCHAR2)
    IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Add User Exception to Log';
        
        INSERT INTO exception_log (code, logged_at, stacktrace)
            VALUES (p_code, CURRENT_TIMESTAMP, p_stacktrace);
        
        COMMIT;
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
            WHEN OTHERS THEN
                handle_sys_exception(SQLCODE, SQLERRM);
    END add_user_exception;


    -- Procedimento para tratar uma exceção definida por nós
    PROCEDURE handle_user_exception(p_name IN user_exception.name%TYPE)
    IS
        n_code user_exception.code%TYPE;
        v_errm user_exception.errm%TYPE;
        v_stacktrace VARCHAR2(500);
    BEGIN
        SELECT code, errm
            INTO n_code, v_errm
            FROM user_exception
            WHERE name = p_name;
        
        FOR j IN REVERSE 1..UTL_Call_Stack.Dynamic_Depth() LOOP
          v_stacktrace := v_stacktrace || UTL_Call_Stack.Concatenate_Subprogram(UTL_Call_Stack.Subprogram(j)) || ', ';
        END LOOP;
        
				-- remove os dois últimos caracteres da string
        v_stacktrace := SUBSTR(v_stacktrace, 0, LENGTH(v_stacktrace) - 2);
        log_exception(n_code, v_stacktrace);

        RAISE_APPLICATION_ERROR(
            n_code,
            v_errm
        );

        ROLLBACK;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                handle_user_exception('exception_not_defined');
    END handle_user_exception;


    -- Procedimento para tratar uma exceção do sistema
    PROCEDURE handle_sys_exception(
        p_code IN INT,
        p_errm IN VARCHAR2)
    IS
        v_stacktrace VARCHAR2(500);
    BEGIN
        FOR j IN REVERSE 1..UTL_Call_Stack.Dynamic_Depth() LOOP 
          v_stacktrace := v_stacktrace || ', ' || UTL_Call_Stack.Concatenate_Subprogram(UTL_Call_Stack.Subprogram(j));
        END LOOP;

				-- remove os dois últimos caracteres da string
				v_stacktrace := SUBSTR(v_stacktrace, 0, LENGTH(v_stacktrace) - 2);
        log_exception(p_code, v_stacktrace);
        
        -- A instrução seguinte imprime o nome do programa que chamou a função handle_sys_exception
        dbms_output.PUT_LINE(v_stacktrace);
        dbms_output.PUT_LINE(p_errm);
        
        log_exception(p_code, v_stacktrace);
        
        ROLLBACK;
    END handle_sys_exception;

END exception_handler;
/