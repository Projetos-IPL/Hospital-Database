-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Corpo do pacote ET_CONSULTA

CREATE OR REPLACE PACKAGE BODY et_consulta AS

    PROCEDURE registar_consulta(
        p_id_processo      IN consulta.id_processo%TYPE,
        p_nif_funcionario    IN consulta.nif_funcionario%TYPE,
        p_id_estado_paciente IN consulta.id_estado_paciente%TYPE,
        p_relatorio          IN VARCHAR2
    )
    IS
        d_dta_alta DATE;
        n_id_relatorio INT;
        n_count_processo INT;
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Registar Consulta';
        
        SELECT COUNT(id_processo) INTO n_count_processo
        FROM processo
        WHERE id_processo = p_id_processo;
        
        IF n_count_processo = 0 THEN
            RAISE et_processo.ex_processo_nao_encontrado;
        END IF;
        
        -- verifica se processo ainda está ativo
        IF NOT validar_nova_consulta(p_id_processo) THEN
            RAISE ex_consulta_em_processo_finalizado;
        END IF;
        
        -- Criar registo na tabela Relatório
        n_id_relatorio := et_relatorio.adicionar_relatorio(p_nif_funcionario, p_relatorio, 'CON');

        -- Criar o registo na tabela Consulta, utilizando o ID do relatório criado acima.
        INSERT INTO consulta (id_processo, id_relatorio, nif_funcionario, id_estado_paciente)
            VALUES (p_id_processo, n_id_relatorio, p_nif_funcionario, p_id_estado_paciente);
            
        COMMIT;
        
        EXCEPTION
            WHEN ex_consulta_em_processo_finalizado THEN
                exception_handler.handle_user_exception('consulta_em_processo_finalizado');
            WHEN et_processo.ex_processo_nao_encontrado THEN
                exception_handler.handle_user_exception('processo_nao_encontrado');
            WHEN et_processo.ex_alteracao_invalida THEN
                exception_handler.handle_user_exception('alteracao_processo_invalida');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END registar_consulta;

    -- Função para validar se é permitido registar uma nova consulta a um processo
    FUNCTION validar_nova_consulta(
        p_id_processo IN consulta.id_processo%TYPE)
    RETURN BOOLEAN IS
        dt_dta_alta DATE;
    BEGIN
        -- Verificar se o processo ainda está ativo
        SELECT dta_alta INTO dt_dta_alta
            FROM processo
            WHERE id_processo = p_id_processo;

        IF dt_dta_alta IS NOT NULL THEN
            RETURN FALSE;
        END IF;

        RETURN TRUE;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN FALSE;
    END validar_nova_consulta;

    FUNCTION obter_data_ultima_consulta(p_id_processo IN consulta.id_processo%TYPE)
    RETURN DATE DETERMINISTIC IS
        d_data_ultima_consulta DATE;
    BEGIN
        SELECT MAX(dta_realizacao)
            INTO d_data_ultima_consulta
            FROM consulta
            WHERE p_id_processo IN id_processo;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END obter_data_ultima_consulta;

END et_consulta;
/