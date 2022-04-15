BEGIN
    SET TRANSACTION READ WRITE NAME 'create_user_exceptions';

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
            -20887,
            'nome_invalido',
            'Nome da pessoa inválido. O nome não pode conter números ou carateres especiais'
    );

    exception_handler.add_user_exception(
        -20699,
        'alteracao_relatorio',
        'Tentativa de alteração de um relatório.'
    );

    exception_handler.add_user_exception(
        -20998,
        'tratamento_repetido',
        'Tentativa de abertura de tratamento repetido para o mesmo paciente.'
    );

    exception_handler.add_user_exception(
        -20997,
        'tratamento_nao_encontrado',
        'Tratamento não encontrado.'
    );

    exception_handler.add_user_exception(
        -20996,
        'finalizacao_repetida',
        'Tentativa de finalizar tratamento já finalizado.'
    );
    
    exception_handler.add_user_exception(
        -20995,
        'alteracao_invalida',
        'Tentativa de alteração do tratamento não permitida.'
    );
    
    exception_handler.add_user_exception(
        -20101,
        'excecao_mal_formatada',
        'Nome/código de exceção mal formatada.'
    );

	exception_handler.add_user_exception(
		-20501,
		'alteracao_cirurgia',
		'Alteração/remoção de uma cirurgia não permitida!'
		);

    COMMIT;

END;
/