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
        p_n_utente_saude IN paciente.n_utente_saude%TYPE
    );

END et_pessoa;
/

