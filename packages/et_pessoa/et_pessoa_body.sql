CREATE OR REPLACE PACKAGE BODY et_pessoa AS

    PROCEDURE adicionar_pessoa(p_rec_pessoa IN pessoa%ROWTYPE) IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Adicionar';
        INSERT INTO pessoa VALUES p_rec_pessoa;
        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.PUT_LINE('Error code: '|| SQLCODE);
                dbms_output.PUT_LINE(SQLERRM);
                ROLLBACK;

    END adicionar_pessoa;

    PROCEDURE adicionar_paciente(
        p_nif            IN pessoa.nif%TYPE,
        p_prim_nome      IN pessoa.prim_nome%TYPE,
        p_ult_nome       IN pessoa.ult_nome%TYPE,
        p_morada         IN pessoa.morada%TYPE,
        p_telefone       IN pessoa.telefone%TYPE,
        p_n_utente_saude IN paciente.n_utente_saude%TYPE
    )
    IS
        rec_pessoa pessoa%ROWTYPE;
    BEGIN
        rec_pessoa.nif := p_nif;
        rec_pessoa.prim_nome := p_prim_nome;
        rec_pessoa.ult_nome := p_ult_nome;
        rec_pessoa.morada := p_morada;
        rec_pessoa.telefone := p_telefone;

        adicionar_pessoa(rec_pessoa);

        SET TRANSACTION READ WRITE NAME 'Adicionar paciente';

        INSERT INTO paciente
            VALUES (p_nif, p_n_utente_saude);

        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.PUT_LINE('Error code: '|| SQLCODE);
                dbms_output.PUT_LINE(SQLERRM);
            ROLLBACK;

    END adicionar_paciente;

END et_pessoa;

