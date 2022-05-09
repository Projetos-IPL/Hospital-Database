BEGIN


    et_pessoa.adicionar_paciente(
            p_nif => 123123001,
            p_prim_nome => 'João',
            p_ult_nome => 'Santos',
            p_morada => 'Rua dos Monges, 31',
            p_t_telefone => et_pessoa.t_telefone('910123001'),
            p_dta_nasc => TO_DATE('01-04-2000', 'dd-mm-yyyy'),
            p_n_utente_saude => 123123101,
            p_id_area_atuacao => 4
        );

    et_pessoa.adicionar_paciente(
            p_nif => 123123002,
            p_prim_nome => 'Ana',
            p_ult_nome => 'Mota',
            p_morada => 'Avenida João de Deus, 2',
            p_t_telefone => et_pessoa.t_telefone('910123002'),
            p_dta_nasc => TO_DATE('12-07-2002', 'dd-mm-yyyy'),
            p_n_utente_saude => 123123102,
            p_id_area_atuacao => 2
        );

    et_pessoa.adicionar_paciente(
            p_nif => 123123003,
            p_prim_nome => 'Mário',
            p_ult_nome => 'Lopes',
            p_morada => 'Travessa 25 de Abril, 9 - R/C',
            p_t_telefone => et_pessoa.t_telefone('910123003'),
            p_dta_nasc => TO_DATE('13-11-2001', 'dd-mm-yyyy'),
            p_n_utente_saude => 123123103,
            p_id_area_atuacao => 7
        );

    et_pessoa.adicionar_enfermeiro(
            p_nif => 123123004,
            p_prim_nome => 'Manuel',
            p_ult_nome => 'Moreira',
            p_morada => 'Rua das Flores, 12',
            p_t_telefone => et_pessoa.t_telefone(910123004),
            p_dta_nasc => TO_DATE('02-09-1999', 'dd-mm-yyyy')
        );

    et_pessoa.adicionar_enfermeiro(
            p_nif => 123123005,
            p_prim_nome => 'Vítor',
            p_ult_nome => 'Távora',
            p_morada => 'Avenida 5 de Outubro, 126',
            p_t_telefone => et_pessoa.t_telefone(910123005),
            p_dta_nasc => TO_DATE('19-06-1982', 'dd-mm-yyyy')
        );

    et_pessoa.adicionar_medico(
            p_nif => 123123006,
            p_prim_nome => 'João',
            p_ult_nome => 'Ramos',
            p_morada => 'Travessa dos Comboios, 5',
            p_t_telefone => et_pessoa.t_telefone(910123006),
            p_dta_nasc => TO_DATE('30-04-1998', 'dd-mm-yyyy'),
            p_id_area_atuacao => 2,
            p_cedula => 1000
        );

    et_pessoa.adicionar_medico(
            p_nif => 123123007,
            p_prim_nome => 'Marisa',
            p_ult_nome => 'Seabra',
            p_morada => 'Rua das Torres, 38',
            p_t_telefone => et_pessoa.t_telefone(910123007),
            p_dta_nasc => TO_DATE('18-08-2000', 'dd-mm-yyyy'),
            p_id_area_atuacao => 4,
            p_cedula => 1001
        );

    COMMIT;

END;
/