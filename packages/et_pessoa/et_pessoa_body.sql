CREATE OR REPLACE PACKAGE BODY et_pessoa AS


    /* Procedimento para adicionar uma pessoa, como a entidade pessoa tem
       uma disjunção obrigatória não é efetuado o commit neste procedimento. */
    PROCEDURE adicionar_pessoa(p_rec_pessoa IN pessoa%ROWTYPE) IS
    BEGIN
        INSERT INTO pessoa VALUES p_rec_pessoa;
				
        EXCEPTION
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END adicionar_pessoa;


    PROCEDURE adicionar_paciente(
        p_nif             IN pessoa.nif%TYPE,
        p_prim_nome       IN pessoa.prim_nome%TYPE,
        p_ult_nome        IN pessoa.ult_nome%TYPE,
        p_morada          IN pessoa.morada%TYPE,
        p_telefone        IN pessoa.telefone%TYPE,
        p_dta_nasc        IN pessoa.dta_nasc%TYPE,
        p_n_utente_saude  IN paciente.n_utente_saude%TYPE,
        p_id_area_atuacao IN tratamento.id_area_atuacao%TYPE
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

        SET TRANSACTION READ WRITE NAME 'Adicionar paciente';

        adicionar_pessoa(rec_pessoa);

        et_tratamento.registar_primeiro_tratamento(p_nif, p_id_area_atuacao);

        INSERT INTO paciente
            VALUES (p_nif, p_n_utente_saude);
        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END adicionar_paciente;


    PROCEDURE adicionar_funcionario(p_rec_pessoa IN pessoa%ROWTYPE) IS
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Adicionar Funcionário';
        adicionar_pessoa(p_rec_pessoa);
        INSERT INTO funcionario
            VALUES (p_rec_pessoa.nif);
        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END adicionar_funcionario;
    
    
    PROCEDURE adicionar_enfermeiro(
        p_nif            IN pessoa.nif%TYPE,
        p_prim_nome      IN pessoa.prim_nome%TYPE,
        p_ult_nome       IN pessoa.ult_nome%TYPE,
        p_morada         IN pessoa.morada%TYPE,
        p_telefone       IN pessoa.telefone%TYPE,
        p_dta_nasc       IN pessoa.dta_nasc%TYPE
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


        SET TRANSACTION READ WRITE NAME 'Adicionar Enfermeiro';

        adicionar_funcionario(rec_pessoa);

        INSERT INTO enfermeiro
            VALUES (p_nif);

        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END adicionar_enfermeiro;
    
    
    PROCEDURE adicionar_medico(
        p_nif               IN pessoa.nif%TYPE,
        p_prim_nome         IN pessoa.prim_nome%TYPE,
        p_ult_nome          IN pessoa.ult_nome%TYPE,
        p_morada            IN pessoa.morada%TYPE,
        p_telefone          IN pessoa.telefone%TYPE,
        p_dta_nasc       IN pessoa.dta_nasc%TYPE,
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
        rec_pessoa.dta_nasc := p_dta_nasc;


        SET TRANSACTION READ WRITE NAME 'Adicionar Médico';

        adicionar_funcionario(rec_pessoa);

        INSERT INTO medico
            VALUES (p_nif, p_id_area_atuacao);

        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END adicionar_medico;

END et_pessoa;

