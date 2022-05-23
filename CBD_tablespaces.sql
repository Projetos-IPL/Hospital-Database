-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Tablespaces


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating tablespaces...');


-- Drop tablespaces if exist
DROP TABLESPACE tbs_tables;
DROP TABLESPACE tbs_indexes;


-- Option REUSE to use the existing files in the OS
CREATE TABLESPACE tbs_tables
    DATAFILE 'tbs_tables.dbf'
    SIZE 1024M
		REUSE;


CREATE TABLESPACE tbs_indexes
    DATAFILE 'tbs_indexes.dbf'
    SIZE 1024M
		REUSE;
