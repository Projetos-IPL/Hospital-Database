CREATE OR REPLACE VIEW processo_dados_view AS
SELECT  p.nif,
        p.prim_nome,
        p.ult_nome,
        p.dta_nasc,
        t.id_processo,
       aa.id_area_atuacao,
        aa.descricao AS "Descricao Area Atuacao",
        t.dta_inicio,
        t.dta_alta
FROM processo       t,
     area_atuacao     aa,
     pessoa           p
WHERE t.nif = p.nif
  AND t.id_area_atuacao = aa.id_area_atuacao;
/

CREATE OR REPLACE VIEW medico_area_atuacao_view AS
SELECT p.nif,
       p.prim_nome,
       p.ult_nome,
       aa.id_area_atuacao,
       aa.descricao AS "Descricao Area Atuacao"
FROM pessoa p,
     medico m,
     area_atuacao aa
WHERE p.nif = m.nif
  AND m.id_area_atuacao = aa.id_area_atuacao;
/

COMMIT;