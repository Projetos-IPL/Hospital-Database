CREATE OR REPLACE PACKAGE BODY et_consulta AS

    PROCEDURE registar_consulta(
        p_id_tratamento      IN consulta.id_tratamento%TYPE,
        p_nif_funcionario    IN consulta.nif_funcionario%TYPE,
        p_id_estado_paciente IN consulta.id_estado_paciente%TYPE,
        p_relatorio          IN VARCHAR2
    )
    IS
        d_dta_alta DATE;
        n_id_relatorio INT;
        n_count_tratamento INT;
    BEGIN
        SET TRANSACTION READ WRITE NAME 'Registar Consulta';
        
        SELECT COUNT(id_tratamento) INTO n_count_tratamento
        FROM tratamento
        WHERE id_tratamento = p_id_tratamento;
        
        IF n_count_tratamento = 0 THEN
            RAISE et_tratamento.ex_tratamento_nao_encontrado;
        END IF;
        
        -- verifica se tratamento ainda está ativo
        SELECT dta_alta INTO d_dta_alta
            FROM tratamento
            WHERE id_tratamento = p_id_tratamento;
            
        IF d_dta_alta IS NOT NULL THEN
            RAISE ex_consulta_em_tratamento_finalizado;
        END IF;
        
        -- Criar registo na tabela Relatório
        n_id_relatorio := et_relatorio.adicionar_relatorio(p_nif_funcionario, p_relatorio, 'CON');

        -- Criar o registo na tabela Consulta, utilizando o ID do relatório criado acima.
        INSERT INTO consulta (id_tratamento, id_relatorio, nif_funcionario, id_estado_paciente)
            VALUES (p_id_tratamento, n_id_relatorio, p_nif_funcionario, p_id_estado_paciente);
            
        COMMIT;
        
        EXCEPTION
            WHEN ex_consulta_em_tratamento_finalizado THEN
                exception_handler.handle_user_exception('consulta_em_tratamento_finalizado');
            WHEN et_tratamento.ex_tratamento_nao_encontrado THEN
                exception_handler.handle_user_exception('tratamento_nao_encontrado');
            WHEN et_tratamento.ex_alteracao_invalida THEN
                exception_handler.handle_user_exception('alteracao_tratamento_invalida');
            WHEN OTHERS THEN
                exception_handler.handle_sys_exception(SQLCODE, SQLERRM);
    END registar_consulta;

    -- Função para validar se é permitido registar uma nova consulta a um tratamento
    FUNCTION validar_nova_consulta(
        p_id_tratamento IN consulta.id_tratamento%TYPE)
    RETURN BOOLEAN IS
        dt_dta_alta DATE;
    BEGIN
        -- Verificar se o tratamento ainda está ativo
        SELECT dta_alta INTO dt_dta_alta
            FROM tratamento
            WHERE id_tratamento = p_id_tratamento;

        IF dt_dta_alta IS NOT NULL THEN
            RETURN FALSE;
        END IF;

        RETURN TRUE;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN FALSE;
    END validar_nova_consulta;

END et_consulta;
/