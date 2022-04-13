BEGIN

    et_pessoa.adicionar_paciente(
        887654329,
        'Diogo',
        'Mafra',
        'Rua do Tio, Leiria',
        '912578851',
        TO_DATE('10-11-1978', 'DD-MM-YYYY'),
        887454321,
        2
        );

    ROLLBACK;

END;
