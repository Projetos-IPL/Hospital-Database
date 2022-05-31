-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de utilizador e schema.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating user and schema...');


-- Connect as SYSDBA
CONN / AS sysdba


-- Delete user and cascade for objects (schema)
DROP USER PROJETO CASCADE;


-- Create user and schema
CREATE USER PROJETO IDENTIFIED BY Projeto_22;


-- Grant privileges to schema user
GRANT RESOURCE TO PROJETO;
GRANT CREATE VIEW TO PROJETO;
GRANT CREATE TABLESPACE TO PROJETO;
GRANT EXECUTE ON DBMS_CRYPTO TO PROJETO;
GRANT CREATE SESSION TO PROJETO;

GRANT SELECT ON dba_audit_object TO PROJETO;


-- Connect as PROJETO for the rest of scripts
CONN PROJETO/Projeto_22
