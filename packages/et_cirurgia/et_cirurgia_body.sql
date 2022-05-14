-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Corpo do pacote ET_CIRURGIA

CREATE OR REPLACE PACKAGE BODY et_cirurgia AS

    -- Registar uma nova cirurgia, associando a um processo
    PROCEDURE registar_cirurgia(
        p_id_processo     IN cirurgia.id_processo%TYPE,
        p_id_tipo_cirurgia  IN cirurgia.id_tipo_cirurgia%TYPE,
        p_relatorio         IN relatorio.texto%TYPE,
        p_t_nif_medicos     IN et_pessoa.t_nif)
    IS
        n_id_relatorio               INTEGER;
        n_id_cirurgia                INTEGER;
    BEGIN

        validar_cirurgia(
                p_id_processo=>p_id_processo,
                p_id_tipo_cirurgia=>p_id_tipo_cirurgia,
                p_t_nif_medicos=>p_t_nif_medicos
        );

        -- Criar relatório para a cirurgia
		-- O primeiro médico na lista fica associado ao relatório da cirurgia criada
        n_id_relatorio := et_relatorio.adicionar_relatorio(
                p_nif => p_t_nif_medicos(1),
                p_texto => p_relatorio,
                p_categoria => 'CIR'
            );

        -- Criar cirurgia
        INSERT INTO cirurgia (id_processo, id_relatorio, id_tipo_cirurgia)
        VALUES (p_id_processo, n_id_relatorio, p_id_tipo_cirurgia)
        RETURNING id_cirurgia INTO n_id_cirurgia;

        -- Inserir médicos na tabela de relação
        FOR i IN p_t_nif_medicos.first..p_t_nif_medicos.last
            LOOP
                INSERT INTO medico_cirurgia
                VALUES (p_t_nif_medicos(i), n_id_cirurgia);
            END LOOP;

        COMMIT;

    EXCEPTION
        WHEN ex_cirurgia_em_processo_finalizado THEN
            exception_handler.handle_user_exception('cirurgia_em_processo_finalizado');
        WHEN et_processo.ex_processo_nao_encontrado THEN
            exception_handler.handle_user_exception('processo_nao_encontrado');
        WHEN ex_area_atuacao_nao_corresponde THEN
            exception_handler.handle_user_exception('area_atuacao_nao_corresponde');
        WHEN OTHERS THEN
            exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END registar_cirurgia;


    PROCEDURE validar_cirurgia(
        p_id_processo     IN cirurgia.id_processo%TYPE,
        p_id_tipo_cirurgia  IN cirurgia.id_tipo_cirurgia%TYPE,
        p_t_nif_medicos     IN et_pessoa.t_nif)
    IS
        n_id_area_atuacao_medico     INTEGER;
        n_id_area_atuacao_processo INTEGER;
        n_id_area_atuacao_cirurgia   INTEGER;
        dt_dta_alta DATE;
    BEGIN

        -- Verificar se o processo ainda está ativa
        SELECT dta_alta INTO dt_dta_alta
            FROM processo
            WHERE id_processo = p_id_processo;

        IF dt_dta_alta IS NOT NULL THEN
            RAISE ex_cirurgia_em_processo_finalizado;
        END IF;

        SELECT id_area_atuacao
        INTO n_id_area_atuacao_processo
        FROM processo
        WHERE id_processo = p_id_processo;

        -- Verificar se a área de atuacao dos médicos corresponde à do processo
        FOR i IN p_t_nif_medicos.first..p_t_nif_medicos.last
            LOOP
                SELECT id_area_atuacao
                INTO n_id_area_atuacao_medico
                FROM medico
                WHERE nif = p_t_nif_medicos(i);

                IF n_id_area_atuacao_medico <> n_id_area_atuacao_processo THEN
                    RAISE ex_area_atuacao_nao_corresponde;
                END IF;
            END LOOP;

        -- Verificar se o tipo de cirurgia está corresponde com a área de processo do processo
        SELECT id_area_atuacao
        INTO n_id_area_atuacao_cirurgia
        FROM tipo_cirurgia
        WHERE id_tipo_cirurgia = p_id_tipo_cirurgia;

        IF n_id_area_atuacao_cirurgia <> n_id_area_atuacao_processo THEN
            RAISE ex_area_atuacao_nao_corresponde;
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            RAISE et_processo.ex_processo_nao_encontrado;
    END validar_cirurgia;

END et_cirurgia;
/