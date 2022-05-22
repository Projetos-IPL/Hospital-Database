-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de utilizador e schema.


CONN sys/sys AS sysdba

DROP USER PROJETO CASCADE;

CREATE USER PROJETO
  IDENTIFIED BY Projeto_22;

GRANT dba TO PROJETO;

CONN PROJETO/Projeto_22