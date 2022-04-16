DECLARE

CURSOR cur_tipo_cirurgias IS
	SELECT id_tipo_cirurgia FROM tipo_cirurgia;

BEGIN

		FOR rec_tipo_cirurgia IN cur_tipo_cirurgias
		LOOP
			et_cirurgia.registar_cirurgia(
					p_id_tratamento => 1,
					p_id_tipo_cirurgia => rec_tipo_cirurgia.id_tipo_cirurgia,
					p_relatorio => 'Cirurgia OK.',
					p_t_nif => t_nif(123123006, 123123007)
			);
		END LOOP;

END;