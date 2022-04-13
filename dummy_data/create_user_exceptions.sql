BEGIN

	exception_handler.add_user_exception(
        -20799,
        'consulta_em_tratamento_finalizado',
        'Tentativa de registo de consulta em tratamento já finalizado.'
    );
    
    exception_handler.add_user_exception(
        -20798,
        'alteracao_consulta',
        'Tentativa de alteração de consulta.'
    );
    
    exception_handler.add_user_exception(
        -20899,
        'menor_de_idade',
        'Não é permitido o registo de pessoas com menos de 18 anos.'
    );
    
    exception_handler.add_user_exception(
        -20888,
        'paciente_sem_tratamento',
        'Paciente sem tratamento registado.'
    );
    
    exception_handler.add_user_exception(
        -20699,
        'alteracao_relatorio',
        'Tentativa de alteração de um relatório.'
    );

END;