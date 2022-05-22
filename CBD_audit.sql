-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para configuração de auditoria.


EXECUTE dbms_output.put_line('> Creating audit...');

AUDIT
	UPDATE
ON
	PROJETO.PROCESSO
WHENEVER NOT SUCCESSFUL;
