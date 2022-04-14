CREATE OR REPLACE PACKAGE BODY et_cirurgia AS

    -- Registar uma nova cirurgia, associando a um tratamento
    PROCEDURE registar_cirurgia(
        p_id_tratamento         IN tratamento.id_tratamento%TYPE,
        p_id_tipo_cirurgia      IN tipo_cirurgia.id_tipo_cirurgia%TYPE,
        p_nif_medico            IN medico.nif%TYPE,
        p_relatorio             IN relatorio.texto%TYPE
    )
    IS
        n_id_area_atuacao_medico INTEGER;
        n_id_area_atuacao_tratamento INTEGER;
        n_id_area_atuacao_cirurgia INTEGER;
        n_id_relatorio INTEGER;
    BEGIN
        -- verifica se a área de atuacao do médico corresponde à do tratamento
        SELECT id_area_atuacao INTO n_id_area_atuacao_medico
            FROM medico
            WHERE nif = p_nif_medico;
        
        SELECT id_area_atuacao INTO n_id_area_atuacao_tratamento
            FROM tratamento
            WHERE id_tratamento = p_id_tratamento;
        
        IF n_id_area_atuacao_medico <> n_id_area_atuacao_tratamento THEN
            DBMS_OUTPUT.PUT_LINE('Área de atuação não corresponde! (médico e tratamento)');
        END IF;
        
        -- verifica se o tipo de cirurgia está incluído na área de tratamento do médico
        SELECT id_area_atuacao INTO n_id_area_atuacao_cirurgia
            FROM tipo_cirurgia
            WHERE id_tipo_cirurgia = p_id_tipo_cirurgia;
            
        IF n_id_area_atuacao_cirurgia <> n_id_area_atuacao_tratamento THEN
            DBMS_OUTPUT.PUT_LINE('Área de atuação não corresponde! (cirurgia e tratamento)');
        END IF;
        
        -- criar relatório para a cirurgia
        n_id_relatorio := et_relatorio.adicionar_relatorio(
            p_nif => p_nif_medico,
            p_texto => p_relatorio,
            p_categoria => 'CIR'
        );
        
        -- criar cirurgia
        INSERT INTO cirurgia (id_tratamento, id_relatorio, id_tipo_cirurgia)
            VALUES (p_id_tratamento, n_id_relatorio, p_id_tipo_cirurgia);
        
        COMMIT;
        
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
    END registar_cirurgia;

END et_cirurgia;