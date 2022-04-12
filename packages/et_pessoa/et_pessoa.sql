CREATE OR REPLACE PACKAGE et_pessoa AS

    menor_de_idade EXCEPTION;

    /**
      Procedimento para adicionar uma pessoa
     */
    PROCEDURE adicionar_pessoa(p_rec_pessoa IN pessoa%ROWTYPE);

    /**
      Procedimento para adicionar um paciente
     */
    PROCEDURE adicionar_paciente(
        p_nif            IN pessoa.nif%TYPE,
        p_prim_nome      IN pessoa.prim_nome%TYPE,
        p_ult_nome       IN pessoa.ult_nome%TYPE,
        p_morada         IN pessoa.morada%TYPE,
        p_telefone       IN pessoa.telefone%TYPE,
        p_dta_nasc       IN pessoa.dta_nasc%TYPE,
        p_n_utente_saude IN paciente.n_utente_saude%TYPE
    );
    
    PROCEDURE adicionar_enfermeiro(
        p_nif            IN pessoa.nif%TYPE,
        p_prim_nome      IN pessoa.prim_nome%TYPE,
        p_ult_nome       IN pessoa.ult_nome%TYPE,
        p_morada         IN pessoa.morada%TYPE,
        p_telefone       IN pessoa.telefone%TYPE
    );
    
    PROCEDURE adicionar_medico(
        p_nif               IN pessoa.nif%TYPE,
        p_prim_nome         IN pessoa.prim_nome%TYPE,
        p_ult_nome          IN pessoa.ult_nome%TYPE,
        p_morada            IN pessoa.morada%TYPE,
        p_telefone          IN pessoa.telefone%TYPE,
        p_id_area_atuacao   IN medico.id_area_atuacao%TYPE
    );

END et_pessoa;
/

