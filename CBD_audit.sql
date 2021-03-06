-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para configuração de auditoria.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating audit...');


-- Setup audit for successful updates on PROCESSO table
AUDIT UPDATE
	ON PROJETO.PROCESSO
WHENEVER SUCCESSFUL;
