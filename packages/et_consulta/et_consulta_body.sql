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
        
        -- criar registo na tabela Relatório
        n_id_relatorio := et_relatorio.adicionar_relatorio(p_nif_funcionario, p_relatorio, 'CON');
        
        /**
            Criar o registo na tabela Consulta, utilizando o ID do relatório
            criado acima.
        **/
        INSERT INTO consulta (id_tratamento, id_relatorio, nif_funcionario, id_estado_paciente)
            VALUES (p_id_tratamento, n_id_relatorio, p_nif_funcionario, p_id_estado_paciente);
            
        COMMIT;
        
        EXCEPTION
            WHEN ex_consulta_em_tratamento_finalizado THEN
                RAISE_APPLICATION_ERROR(
                    ex_consulta_em_tratamento_finalizado_error_code,
                    ex_consulta_em_tratamento_finalizado_errm
                );
                ROLLBACK;
            WHEN et_tratamento.ex_tratamento_nao_encontrado THEN
                RAISE_APPLICATION_ERROR(
                    et_tratamento.ex_tratamento_nao_encontrado_error_code,
                    et_tratamento.ex_tratamento_nao_encontrado_errm
                );
                ROLLBACK;
            WHEN OTHERS THEN
                dbms_output.PUT_LINE(utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)));
                dbms_output.PUT_LINE(SQLERRM);
                ROLLBACK;
    END registar_consulta;

END et_consulta;