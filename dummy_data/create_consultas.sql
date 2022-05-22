-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Script para criação de consultas.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating consultas...');

DECLARE
	CURSOR cur_processos IS
		SELECT id_processo FROM PROJETO.processo;
BEGIN
		FOR rec_processo IN cur_processos
		LOOP
			et_consulta.registar_consulta(
					p_id_processo => rec_processo.id_processo,
					p_nif_funcionario => 123123004,
					p_id_estado_paciente => 2,
					p_relatorio => 'Consulta OK.'
			);
		END LOOP;
END;
/
