CREATE OR REPLACE PACKAGE BODY et_pessoa AS

    -- Procedimento para adicionar uma pessoa, como a entidade pessoa tem
    -- uma disjunção obrigatória não é efetuado o commit neste procedimento.
    -- Como este procedimento não é para ser utilizado individualmente o controlo da transação e
    -- exceções não é feito neste nível.
    PROCEDURE adicionar_pessoa(
        p_rec_pessoa IN pessoa%ROWTYPE,
        p_t_telefone IN t_telefone
    ) IS
    BEGIN
        INSERT INTO pessoa VALUES p_rec_pessoa;

        FOR i IN p_t_telefone.FIRST..p_t_telefone.LAST
        LOOP
            INSERT INTO telefone VALUES (p_rec_pessoa.nif, p_t_telefone(i));
        END LOOP;

    END adicionar_pessoa;


    PROCEDURE adicionar_paciente(
        p_nif             IN pessoa.nif%TYPE,
        p_prim_nome       IN pessoa.prim_nome%TYPE,
        p_ult_nome        IN pessoa.ult_nome%TYPE,
        p_morada          IN pessoa.morada%TYPE,
        p_dta_nasc        IN pessoa.dta_nasc%TYPE,
        p_n_utente_saude  IN paciente.n_utente_saude%TYPE,
        p_id_area_atuacao IN processo.id_area_atuacao%TYPE,
        p_t_telefone      IN t_telefone
    )
    IS
        rec_pessoa pessoa%ROWTYPE;
        n_count_pessoa INTEGER;
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Adicionar Paciente';
        rec_pessoa.nif := p_nif;
        rec_pessoa.prim_nome := p_prim_nome;
        rec_pessoa.ult_nome := p_ult_nome;
        rec_pessoa.morada := p_morada;
        rec_pessoa.dta_nasc := p_dta_nasc;

        -- Verificar se pessoa já existe no sistema e adicionar pessoa se não existir
        SELECT COUNT(1) INTO n_count_pessoa
          FROM pessoa
          WHERE nif = p_nif;

        IF n_count_pessoa = 0 THEN
            adicionar_pessoa(rec_pessoa, p_t_telefone);
        END IF;

        et_processo.registar_primeiro_processo(p_nif, p_id_area_atuacao);

        INSERT INTO paciente
            VALUES (p_nif, p_n_utente_saude);

        COMMIT;

        EXCEPTION
            WHEN et_pessoa.ex_menor_de_idade THEN
                exception_handler.handle_user_exception('menor_de_idade');
            WHEN et_pessoa.ex_nome_invalido THEN
                exception_handler.handle_user_exception('nome_invalido');
            WHEN ex_paciente_sem_processo THEN
                exception_handler.handle_user_exception('paciente_sem_processo');
            -- Exceção acionada pelo proc. et_processo_registar_primeiro_processo
            WHEN et_processo.ex_paciente_ja_tem_processo THEN
                et_processo.print_error_log;
                et_processo.limpar_error_log;
                exception_handler.handle_user_exception('paciente_ja_tem_processo');
            WHEN et_processo.ex_processo_repetido THEN
                exception_handler.handle_user_exception('processo_repetido');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END adicionar_paciente;


    -- Como este procedimento não é para ser utilizado individualmente o controlo da transação
    -- não é feito neste nível. O processo das exceções não é feito pelo mesmo motivo.
    PROCEDURE adicionar_funcionario(
        p_rec_pessoa IN pessoa%ROWTYPE,
        p_t_telefone IN t_telefone
    ) IS
        n_count_pessoa INTEGER;
    BEGIN

        -- Verificar se pessoa já existe no sistema e adicionar pessoa se não existir
        SELECT COUNT(1) INTO n_count_pessoa
          FROM pessoa
          WHERE nif = p_rec_pessoa.nif;

        IF n_count_pessoa = 0 THEN
            adicionar_pessoa(p_rec_pessoa, p_t_telefone);
        END IF;

        INSERT INTO funcionario
            VALUES (p_rec_pessoa.nif);

    END adicionar_funcionario;
    
    
    PROCEDURE adicionar_enfermeiro(
        p_nif            IN pessoa.nif%TYPE,
        p_prim_nome      IN pessoa.prim_nome%TYPE,
        p_ult_nome       IN pessoa.ult_nome%TYPE,
        p_morada         IN pessoa.morada%TYPE,
        p_dta_nasc       IN pessoa.dta_nasc%TYPE,
        p_t_telefone IN t_telefone
    ) IS
        rec_pessoa pessoa%ROWTYPE;
    BEGIN
        rec_pessoa.nif := p_nif;
        rec_pessoa.prim_nome := p_prim_nome;
        rec_pessoa.ult_nome := p_ult_nome;
        rec_pessoa.morada := p_morada;
        rec_pessoa.dta_nasc := p_dta_nasc;


        SET TRANSACTION READ WRITE NAME 'Adicionar Enfermeiro';

        adicionar_funcionario(rec_pessoa, p_t_telefone);

        INSERT INTO enfermeiro
            VALUES (p_nif);

        COMMIT;

        EXCEPTION
            WHEN et_pessoa.ex_menor_de_idade THEN
                exception_handler.handle_user_exception('menor_de_idade');
            WHEN et_pessoa.ex_nome_invalido THEN
                exception_handler.handle_user_exception('nome_invalido');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END adicionar_enfermeiro;
    
    
    PROCEDURE adicionar_medico(
        p_nif               IN pessoa.nif%TYPE,
        p_prim_nome         IN pessoa.prim_nome%TYPE,
        p_ult_nome          IN pessoa.ult_nome%TYPE,
        p_morada            IN pessoa.morada%TYPE,
        p_dta_nasc          IN pessoa.dta_nasc%TYPE,
        p_id_area_atuacao   IN medico.id_area_atuacao%TYPE,
        p_t_telefone        IN t_telefone,
        p_cedula            IN medico.cedula%TYPE
    )
    IS
        rec_pessoa pessoa%ROWTYPE;
    BEGIN
        rec_pessoa.nif := p_nif;
        rec_pessoa.prim_nome := p_prim_nome;
        rec_pessoa.ult_nome := p_ult_nome;
        rec_pessoa.morada := p_morada;
        rec_pessoa.dta_nasc := p_dta_nasc;


        SET TRANSACTION READ WRITE NAME 'Adicionar Médico';

        adicionar_funcionario(rec_pessoa, p_t_telefone);

        INSERT INTO medico
            VALUES (p_nif, p_id_area_atuacao, p_cedula);

        COMMIT;

        EXCEPTION
            WHEN et_pessoa.ex_menor_de_idade THEN
                exception_handler.handle_user_exception('menor_de_idade');
            WHEN et_pessoa.ex_nome_invalido THEN
                exception_handler.handle_user_exception('nome_invalido');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END adicionar_medico;

    FUNCTION validar_nome(p_nome IN VARCHAR2)
    RETURN BOOLEAN  IS
    BEGIN

        IF LENGTH(p_nome) < 3 THEN
            RETURN FALSE;
        END IF;

        IF LENGTH(TRIM(TRANSLATE(
            p_nome, c_carateres_nome_validos, ' '
            ))) <> 0
        THEN
            RETURN FALSE;
        ELSE
            RETURN TRUE;
        END IF;

    END validar_nome;

    PROCEDURE validar_pessoa(p_rec_pessoa IN pessoa%ROWTYPE) IS
    BEGIN
        -- Validar idade
        IF calcular_idade(p_rec_pessoa.dta_nasc) < 18 THEN
            RAISE et_pessoa.ex_menor_de_idade;
        END IF;

        -- Validar nome da pessoa, não pode conter números ou carateres especiais.
        IF et_pessoa.validar_nome(p_rec_pessoa.prim_nome || p_rec_pessoa.ult_nome) THEN
            RAISE et_pessoa.ex_nome_invalido;
        END IF;

    END;

    PROCEDURE validar_novo_paciente(p_rec_paciente IN paciente%rowtype)
    IS
        n_count_paciente INT;
    BEGIN
        -- Verificar se paciente tem processo associado
        SELECT COUNT(nif) INTO n_count_paciente
            FROM processo
            WHERE nif = p_rec_paciente.nif;

        IF n_count_paciente = 0 THEN
            RAISE et_pessoa.ex_paciente_sem_processo;
        END IF;

    END;

    PROCEDURE validar_alteracao_pessoa(p_rec_pessoa_antigo IN pessoa%ROWTYPE,
                                       p_rec_pessoa_novo   IN pessoa%ROWTYPE)
    IS
    BEGIN
        IF p_rec_pessoa_antigo.nif      <> p_rec_pessoa_novo.nif
        OR p_rec_pessoa_antigo.dta_nasc <> p_rec_pessoa_novo.dta_nasc
        THEN
            RAISE ex_alteracao_invalida;
        END IF;
    END;

    FUNCTION calcular_idade(p_data IN DATE)
    RETURN NUMBER IS
    BEGIN
        RETURN FLOOR(MONTHS_BETWEEN(SYSDATE, p_data) / 12);
    END;

END et_pessoa;
/

