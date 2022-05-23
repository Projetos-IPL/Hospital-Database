-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de índices


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating indexes...');


-- Indice para otimizar queries a consultas por processo
CREATE INDEX PROJETO.idx_consulta_id_processo ON PROJETO.consulta (id_processo)
    TABLESPACE tbs_indexes;


-- Indice para otimizar queries a cirurgias por processo
CREATE INDEX PROJETO.idx_cirurgia_id_processo ON PROJETO.cirurgia (id_processo)
    TABLESPACE tbs_indexes;


-- Indice para otimizar queries a processos por área de atuação
CREATE INDEX PROJETO.idx_processo_id_area_atuacao ON PROJETO.processo (id_area_atuacao)
    TABLESPACE tbs_indexes;


-- Indice para otimizar queries a processos por nif
CREATE INDEX PROJETO.idx_processo_nif ON PROJETO.processo(nif)
    TABLESPACE tbs_indexes;
