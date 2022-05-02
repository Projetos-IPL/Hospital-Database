BEGIN

    et_cirurgia.registar_cirurgia(
            p_id_processo => 1,
            p_id_tipo_cirurgia => 18,
            p_relatorio => 'Cirurgia OK.',
            p_t_nif_medicos => et_pessoa.t_nif(123123007)
    );
    
    et_cirurgia.registar_cirurgia(
            p_id_processo => 2,
            p_id_tipo_cirurgia => 6,
            p_relatorio => 'Cirurgia OK.',
            p_t_nif_medicos => et_pessoa.t_nif(123123006)
    );

END;
/