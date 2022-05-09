CREATE OR REPLACE VIEW processo_dados_view AS
SELECT  p.nif,
        p.prim_nome,
        p.ult_nome,
        p.dta_nasc,
        t.id_processo,
        aa.id_area_atuacao,
        aa.descricao AS "Descricao Area Atuacao",
        t.dta_inicio,
        t.dta_alta,
        ep.descricao
FROM processo         t,
     area_atuacao     aa,
     pessoa           p,
     estado_paciente  ep
WHERE t.nif = p.nif
  AND t.id_area_atuacao = aa.id_area_atuacao
  AND t.id_estado_paciente = ep.id_estado_paciente;
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


CREATE OR REPLACE VIEW dados_paciente_view AS
SELECT pe.nif,
       pe.prim_nome,
       pe.ult_nome,
       pe.morada,
       pa.n_utente_saude,
       te.telefone
FROM   pessoa pe,
       paciente pa,
       telefone te
WHERE  pe.nif = pa.nif
       AND pe.nif = te.nif;
/

CREATE OR REPLACE VIEW processo_andamento_dados_view AS
SELECT  p.nif,
        p.prim_nome,
        p.ult_nome,
        p.dta_nasc,
        t.id_processo,
        aa.id_area_atuacao,
        aa.descricao AS "Descricao Area Atuacao",
        t.dta_inicio,
        t.dta_alta,
        ep.descricao
FROM processo         t,
     area_atuacao     aa,
     pessoa           p,
     estado_paciente  ep
WHERE t.nif = p.nif
  AND t.id_area_atuacao = aa.id_area_atuacao
  AND t.id_estado_paciente = ep.id_estado_paciente
  AND t.dta_alta IS NULL;
/

CREATE OR REPLACE VIEW processo_total_consultas_view AS
SELECT pro.id_processo                                                             "Id Processo",
       pes.prim_nome || ' ' || pes.ult_nome                                        "Nome Paciente",
       aa.descricao                                                                "Área Atuação",
       (CASE
           WHEN pro.dta_alta IS NULL THEN 'Em andamento'
           ELSE 'Finalizado'
        END)                                                                       "Estado",
       pro.dta_inicio                                                              "Data de ínicio",
       pro.dta_alta                                                                "Data de alta",
       (SELECT COUNT(1) FROM cirurgia cir WHERE cir.id_processo = pro.id_processo) "Total cirurgias",
       (SELECT COUNT(1) FROM consulta con WHERE con.id_processo = pro.id_processo) "Total consultas"
FROM processo pro, pessoa pes, area_atuacao aa
WHERE pro.nif             = pes.nif
  AND pro.id_area_atuacao = aa.id_area_atuacao;


COMMIT;

