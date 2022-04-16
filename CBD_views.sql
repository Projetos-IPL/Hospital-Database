CREATE OR REPLACE VIEW tratamento_dados_view AS
SELECT  p.prim_nome,
        p.ult_nome,
        p.dta_nasc,
        t.id_tratamento,
        aa.descricao,
        t.dta_inicio,
        t.dta_alta
FROM tratamento       t,
       area_atuacao     aa,
       pessoa           p
WHERE t.nif = p.nif
  AND t.id_area_atuacao = aa.id_area_atuacao;
/

COMMIT;