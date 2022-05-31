-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Tablespaces


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating tablespaces...');


CONN / AS SYSDBA;

-- Drop tablespaces if exist
DROP TABLESPACE tbs_tables INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE tbs_indexes INCLUDING CONTENTS AND DATAFILES;


-- Option REUSE to use the existing files in the OS

CREATE TABLESPACE tbs_tables
  DATAFILE 'tbs_tables.dbf' SIZE 1M REUSE
		AUTOEXTEND ON NEXT 500K
	UNIFORM SIZE 40K;


CREATE TABLESPACE tbs_indexes
	DATAFILE 'tbs_indexes.dbf' SIZE 5M REUSE
		AUTOEXTEND ON NEXT 500K
	UNIFORM SIZE 40K;


CONN PROJETO/Projeto_22;