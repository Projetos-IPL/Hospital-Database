-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Tablespaces

CREATE TABLESPACE tbs_tables
    DATAFILE 'tbs_tables.dbf'
    SIZE 1024M;

CREATE TABLESPACE tbs_indexes
    DATAFILE 'tbs_indexes.dbf'
    SIZE 1024M;