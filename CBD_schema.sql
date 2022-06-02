-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de utilizador e schema.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating user and schema...');


-- Connect as SYSDBA
CONN / AS sysdba


-- Delete user and cascade for objects (schema)
DROP USER PROJETO CASCADE;


-- Tablespaces
DROP TABLESPACE tbs_tables
	INCLUDING CONTENTS AND DATAFILES;
	
DROP TABLESPACE tbs_indexes
	INCLUDING CONTENTS AND DATAFILES;


-- Option REUSE to use the existing files in the OS
CREATE TABLESPACE tbs_tables
  DATAFILE 'tbs_tables.dbf' SIZE 1M REUSE
		AUTOEXTEND ON NEXT 500K
	UNIFORM SIZE 40K;


CREATE TABLESPACE tbs_indexes
	DATAFILE 'tbs_indexes.dbf' SIZE 5M REUSE
		AUTOEXTEND ON NEXT 500K
	UNIFORM SIZE 40K;


-- Create user and schema
CREATE USER PROJETO
	IDENTIFIED BY Projeto_22
	QUOTA 500M ON TBS_INDEXES
	QUOTA 500M ON TBS_TABLES;


-- Grant privileges to schema user
GRANT RESOURCE TO PROJETO WITH ADMIN OPTION;
GRANT CREATE VIEW TO PROJETO WITH ADMIN OPTION;
GRANT CREATE TABLESPACE TO PROJETO WITH ADMIN OPTION;
GRANT CREATE SESSION TO PROJETO WITH ADMIN OPTION;
GRANT CREATE ROLE TO PROJETO WITH ADMIN OPTION;
GRANT DROP ROLE TO PROJETO;

GRANT CREATE TABLE TO PROJETO WITH ADMIN OPTION;
GRANT UPDATE ANY TABLE TO PROJETO WITH ADMIN OPTION;
GRANT CREATE SEQUENCE TO PROJETO WITH ADMIN OPTION;
GRANT CREATE ANY PROCEDURE TO PROJETO WITH ADMIN OPTION;

GRANT EXECUTE ON DBMS_CRYPTO TO PROJETO;
GRANT SELECT ON SYS.DBA_AUDIT_OBJECT TO PROJETO;

-- Delete roles
DROP ROLE developer;
DROP ROLE application;
DROP ROLE manager;

