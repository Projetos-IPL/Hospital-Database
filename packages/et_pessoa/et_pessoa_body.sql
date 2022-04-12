CREATE OR REPLACE PACKAGE BODY et_pessoa AS

    PROCEDURE adicionar_pessoa(p_rec_pessoa IN pessoa%ROWTYPE) IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Adicionar';
        INSERT INTO pessoa VALUES p_rec_pessoa;
        COMMIT;

        EXCEPTION
            WHEN menor_de_idade THEN
                dbms_output.PUT_LINE('Não é permitido o registo de pessoas com menos de 18 anos.');
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
        p_dta_nasc       IN pessoa.dta_nasc%TYPE,
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
        rec_pessoa.dta_nasc := p_dta_nasc;

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


    PROCEDURE adicionar_funcionario(p_rec_pessoa IN pessoa%ROWTYPE) IS
    BEGIN
        adicionar_pessoa(p_rec_pessoa);
        
        SET TRANSACTION READ WRITE NAME 'Adicionar Funcionário';
        INSERT INTO funcionario VALUES (p_rec_pessoa.nif);
        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.PUT_LINE('Error code: '|| SQLCODE);
                dbms_output.PUT_LINE(SQLERRM);
                ROLLBACK;

    END adicionar_funcionario;
    
    
    PROCEDURE adicionar_enfermeiro(
        p_nif            IN pessoa.nif%TYPE,
        p_prim_nome      IN pessoa.prim_nome%TYPE,
        p_ult_nome       IN pessoa.ult_nome%TYPE,
        p_morada         IN pessoa.morada%TYPE,
        p_telefone       IN pessoa.telefone%TYPE
    )
    IS
        rec_pessoa pessoa%ROWTYPE;
    BEGIN
        rec_pessoa.nif := p_nif;
        rec_pessoa.prim_nome := p_prim_nome;
        rec_pessoa.ult_nome := p_ult_nome;
        rec_pessoa.morada := p_morada;
        rec_pessoa.telefone := p_telefone;

        adicionar_funcionario(rec_pessoa);

        SET TRANSACTION READ WRITE NAME 'Adicionar Enfermeiro';

        INSERT INTO enfermeiro
            VALUES (p_nif);

        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.PUT_LINE('Error code: '|| SQLCODE);
                dbms_output.PUT_LINE(SQLERRM);
            ROLLBACK;

    END adicionar_enfermeiro;
    
    
    PROCEDURE adicionar_medico(
        p_nif               IN pessoa.nif%TYPE,
        p_prim_nome         IN pessoa.prim_nome%TYPE,
        p_ult_nome          IN pessoa.ult_nome%TYPE,
        p_morada            IN pessoa.morada%TYPE,
        p_telefone          IN pessoa.telefone%TYPE,
        p_id_area_atuacao   IN medico.id_area_atuacao%TYPE
    )
    IS
        rec_pessoa pessoa%ROWTYPE;
    BEGIN
        rec_pessoa.nif := p_nif;
        rec_pessoa.prim_nome := p_prim_nome;
        rec_pessoa.ult_nome := p_ult_nome;
        rec_pessoa.morada := p_morada;
        rec_pessoa.telefone := p_telefone;

        adicionar_funcionario(rec_pessoa);

        SET TRANSACTION READ WRITE NAME 'Adicionar Médico';

        INSERT INTO medico
            VALUES (p_nif, p_id_area_atuacao);

        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.PUT_LINE('Error code: '|| SQLCODE);
                dbms_output.PUT_LINE(SQLERRM);
            ROLLBACK;

    END adicionar_medico;

END et_pessoa;

