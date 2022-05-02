DECLARE

CURSOR cur_processos IS
	SELECT id_processo FROM processo;

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