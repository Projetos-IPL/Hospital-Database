DECLARE

CURSOR cur_tratamentos IS
	SELECT id_tratamento FROM tratamento;

BEGIN

		FOR rec_tratamento IN cur_tratamentos
		LOOP
			et_consulta.registar_consulta(
					p_id_tratamento => rec_tratamento.id_tratamento,
					p_nif_funcionario => 123123004,
					p_id_estado_paciente => 2,
					p_relatorio => 'Consulta OK.'
			);
		END LOOP;

END;
/