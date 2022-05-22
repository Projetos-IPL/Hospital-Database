-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de utilizador e schema.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating user and schema...');

CONN / AS sysdba;

DROP USER PROJETO CASCADE;

CREATE USER PROJETO
  IDENTIFIED BY Projeto_22;

GRANT DBA TO PROJETO;

CONN PROJETO/Projeto_22;
