CREATE OR REPLACE PACKAGE BODY exception_handler AS

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
    BEGIN

        SELECT code, errm
            INTO n_code, v_errm
            FROM user_exception
            WHERE name = p_name;

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
    BEGIN
        -- A instrução seguinte imprime o nome do programa que chamou a função handle_sys_exception
        dbms_output.PUT_LINE(utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(2)));
        dbms_output.PUT_LINE(p_errm);
        ROLLBACK;
    END handle_sys_exception;

END exception_handler;
/