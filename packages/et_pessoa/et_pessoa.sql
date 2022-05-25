-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Cabeçalho do pacote ET_PESSOA


CREATE OR REPLACE PACKAGE et_pessoa AS

    ex_menor_de_idade EXCEPTION;
    ex_nome_invalido EXCEPTION;
    ex_paciente_sem_processo EXCEPTION;
    ex_alteracao_invalida EXCEPTION;
    ex_tentativa_eliminar EXCEPTION;

    c_carateres_nome_validos CONSTANT VARCHAR2(100) :='aáàâãbcdeéèêfghiíìîjklmnoóòõôpqrstuúùûvwxyzç';
    TYPE t_nif IS TABLE OF pessoa.nif%TYPE;
    TYPE t_telefone IS TABLE OF VARCHAR2(9);

    /**
      Procedimento para adicionar um paciente
     */
    PROCEDURE adicionar_paciente(
        p_nif             IN pessoa.nif%TYPE,
        p_prim_nome       IN pessoa.prim_nome%TYPE,
        p_ult_nome        IN pessoa.ult_nome%TYPE,
        p_morada          IN pessoa.morada%TYPE,
        p_dta_nasc        IN pessoa.dta_nasc%TYPE,
        p_n_utente_saude  IN paciente.n_utente_saude%TYPE,
        p_id_area_atuacao IN processo.id_area_atuacao%TYPE,
        p_t_telefone      IN t_telefone
    );
    
    PROCEDURE adicionar_enfermeiro(
        p_nif            IN pessoa.nif%TYPE,
        p_prim_nome      IN pessoa.prim_nome%TYPE,
        p_ult_nome       IN pessoa.ult_nome%TYPE,
        p_morada         IN pessoa.morada%TYPE,
        p_dta_nasc       IN pessoa.dta_nasc%TYPE,
        p_t_telefone     IN t_telefone
    );
    
    PROCEDURE adicionar_medico(
        p_nif               IN pessoa.nif%TYPE,
        p_prim_nome         IN pessoa.prim_nome%TYPE,
        p_ult_nome          IN pessoa.ult_nome%TYPE,
        p_morada            IN pessoa.morada%TYPE,
        p_dta_nasc          IN pessoa.dta_nasc%TYPE,
        p_id_area_atuacao   IN medico.id_area_atuacao%TYPE,
        p_t_telefone        IN t_telefone,
        p_cedula            IN medico.cedula%TYPE
    );

    -- Função para validar o nome, devolve verdadeiro se for válido e falso se não.
    FUNCTION validar_nome(p_nome IN VARCHAR2) RETURN BOOLEAN;

    -- Procedimento para validar uma nova pessoa
    PROCEDURE validar_pessoa(p_rec_pessoa IN pessoa%ROWTYPE);

    -- Procedimento para validar um novo paciente
    PROCEDURE validar_novo_paciente(p_rec_paciente IN paciente%ROWTYPE);

    -- Procedimento para validar alterações a pessoas
    PROCEDURE validar_alteracao_pessoa(p_rec_pessoa_antigo IN pessoa%ROWTYPE,
                                       p_rec_pessoa_novo   IN pessoa%ROWTYPE);

    -- Função para calcular idade
    FUNCTION calcular_idade(p_data IN DATE ) RETURN NUMBER;


END et_pessoa;
/

