CREATE OR REPLACE PACKAGE exception_handler AS

    exception_code_out_of_bounds EXCEPTION;
    ex_mal_formatada EXCEPTION;

    -- Procedimento para adicionar uma exceção ao histórico
    PROCEDURE log_exception(
        p_code       IN INT,
        p_stacktrace IN VARCHAR2,
        p_errm       IN VARCHAR2
        );

    -- Procedimento para adicionar uma user exception
    PROCEDURE add_user_exception (
        p_code IN user_exception.code%TYPE,
        p_name IN user_exception.name%TYPE,
        p_errm IN user_exception.errm%TYPE);

    -- Procedimento para tratar uma exceção definida por nós
    PROCEDURE handle_user_exception(p_name IN user_exception.name%TYPE);

    -- Procedimento para tratar uma exceção do sistema
    PROCEDURE handle_sys_exception(
        p_code IN INT,
        p_errm IN VARCHAR2);

END exception_handler;
/