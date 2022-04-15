CREATE OR REPLACE PACKAGE BODY et_cirurgia AS

    -- Registar uma nova cirurgia, associando a um tratamento
    PROCEDURE registar_cirurgia(
        p_id_tratamento     IN cirurgia.id_tratamento%TYPE,
        p_id_tipo_cirurgia  IN cirurgia.id_tipo_cirurgia%TYPE,
        p_relatorio         IN relatorio.texto%TYPE,
        p_t_nif             IN et_pessoa.t_nif)
    IS
        n_id_relatorio               INTEGER;
        n_id_cirurgia                INTEGER;
    BEGIN

        IF NOT validar_cirurgia(
                p_id_tratamento=>p_id_tratamento,
                p_id_tipo_cirurgia=>p_id_tipo_cirurgia,
                p_t_nif=>p_t_nif)
        THEN
            RAISE ex_area_atuacao_nao_corresponde;
        END IF;

        -- Criar relatório para a cirurgia
        n_id_relatorio := et_relatorio.adicionar_relatorio(
                p_nif => p_t_nif(1),
                p_texto => p_relatorio,
                p_categoria => 'CIR'
            );

        -- Criar cirurgia
        INSERT INTO cirurgia (id_tratamento, id_relatorio, id_tipo_cirurgia)
        VALUES (p_id_tratamento, n_id_relatorio, p_id_tipo_cirurgia)
        RETURNING id_cirurgia INTO n_id_cirurgia;

        -- Inserir médicos na tabela de relação
        FOR i IN p_t_nif.first..p_t_nif.last
            LOOP
                INSERT INTO medico_cirurgia
                VALUES (p_t_nif(i), n_id_cirurgia);
            END LOOP;

        COMMIT;

    EXCEPTION
        WHEN ex_area_atuacao_nao_corresponde THEN
            exception_handler.handle_user_exception('area_atuacao_nao_corresponde');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END registar_cirurgia;


    FUNCTION validar_cirurgia(
        p_id_tratamento     IN cirurgia.id_tratamento%TYPE,
        p_id_tipo_cirurgia  IN cirurgia.id_tipo_cirurgia%TYPE,
        p_t_nif             IN et_pessoa.t_nif)
    RETURN BOOLEAN IS
        n_id_area_atuacao_medico     INTEGER;
        n_id_area_atuacao_tratamento INTEGER;
        n_id_area_atuacao_cirurgia   INTEGER;
    BEGIN

        SELECT id_area_atuacao
        INTO n_id_area_atuacao_tratamento
        FROM tratamento
        WHERE id_tratamento = p_id_tratamento;

        -- Verificar se a área de atuacao dos médicos corresponde à do tratamento
        FOR i IN p_t_nif.first..p_t_nif.last
            LOOP
                SELECT id_area_atuacao
                INTO n_id_area_atuacao_medico
                FROM medico
                WHERE nif = p_t_nif(i);

                IF n_id_area_atuacao_medico <> n_id_area_atuacao_tratamento THEN
                    RAISE ex_area_atuacao_nao_corresponde;
                END IF;
            END LOOP;

        -- Verificar se o tipo de cirurgia está corresponde com a área de tratamento do tratamento
        SELECT id_area_atuacao
        INTO n_id_area_atuacao_cirurgia
        FROM tipo_cirurgia
        WHERE id_tipo_cirurgia = p_id_tipo_cirurgia;

        IF n_id_area_atuacao_cirurgia <> n_id_area_atuacao_tratamento THEN
            RAISE ex_area_atuacao_nao_corresponde;
        END IF;

        RETURN TRUE;

    EXCEPTION
        WHEN no_data_found THEN
            RETURN FALSE;
        WHEN ex_area_atuacao_nao_corresponde THEN
            RETURN FALSE;
    END validar_cirurgia;

END et_cirurgia;
/