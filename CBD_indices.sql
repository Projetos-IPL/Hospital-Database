

-- Indice para otimizar queries a consultas por processo
CREATE INDEX idx_consulta_id_processo ON consulta (id_processo);

-- Indice para otimizar queries a cirurgias por processo
CREATE INDEX idx_cirurgia_id_processo ON cirurgia (id_processo);

-- Indice para otimizar queries a processos por área de atuação
CREATE BITMAP INDEX idx_processo_id_area_atuacao ON processo (id_area_atuacao);

-- Indice para otimizar queries a processos por nif
CREATE INDEX idx_processo_nif ON processo(nif);
