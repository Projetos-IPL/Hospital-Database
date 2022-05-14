-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de views

CREATE OR REPLACE VIEW processo_dados_view AS
SELECT pe.nif,
       pe.prim_nome,
       pe.ult_nome,
       pe.dta_nasc,
       p.id_processo,
       aa.id_area_atuacao,
       aa.descricao AS "Descricao Area Atuacao",
       p.dta_inicio,
       p.dta_alta,
       ep.descricao
FROM processo p,
     area_atuacao aa,
     pessoa pe,
     estado_paciente ep
WHERE p.nif = pe.nif
  AND p.id_area_atuacao = aa.id_area_atuacao
  AND p.id_estado_paciente = ep.id_estado_paciente (+);
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
FROM pessoa pe,
     paciente pa,
     telefone te
WHERE pe.nif = pa.nif
  AND pe.nif = te.nif;
/

CREATE OR REPLACE VIEW processo_total_consultas_view AS
SELECT pro.id_processo                                                             "Id Processo",
       pes.prim_nome || ' ' || pes.ult_nome                                        "Nome Paciente",
       aa.descricao                                                                "Área Atuação",
       (CASE
            WHEN pro.dta_alta IS NULL THEN 'Em andamento'
            ELSE 'Finalizado'
           END)                                                                    "Estado",
       pro.dta_inicio                                                              "Data de ínicio",
       pro.dta_alta                                                                "Data de alta",
       (SELECT COUNT(1) FROM cirurgia cir WHERE cir.id_processo = pro.id_processo) "Total cirurgias",
       (SELECT COUNT(1) FROM consulta con WHERE con.id_processo = pro.id_processo) "Total consultas"
FROM processo pro,
     pessoa pes,
     area_atuacao aa
WHERE pro.nif = pes.nif
  AND pro.id_area_atuacao = aa.id_area_atuacao;
/


CREATE OR REPLACE VIEW processos_ativos_view AS
SELECT /*+ parallel(p,5) */
       p.id_processo,
       pe.nif,
       pe.prim_nome || ' ' || pe.ult_nome    "Paciente",
       et_pessoa.calcular_idade(pe.dta_nasc) "Idade",
       aa.descricao     AS                   "Área de atuação",
       p.dta_inicio     AS                   "Data de ínicio",
       ep.descricao     AS                   "Estado",
       c.dta_realizacao AS                   "Última Consulta"
FROM processo p,
     area_atuacao aa,
     pessoa pe,
     estado_paciente ep,
     consulta c
WHERE p.nif = pe.nif
  AND p.dta_alta IS NULL
  AND p.id_processo = c.id_processo (+)
  AND p.id_estado_paciente = ep.id_estado_paciente (+)
  AND p.id_area_atuacao = aa.id_area_atuacao
  AND (c.dta_realizacao = (SELECT MAX(dta_realizacao)
                           FROM consulta
                           WHERE consulta.id_processo = c.id_processo)
    OR c.dta_realizacao IS NULL);
/


CREATE OR REPLACE VIEW estatisticas_area_atuacao_view AS
SELECT aa.descricao                               "Área de atuação",
       COUNT(p.id_processo)                       "Total Processos",
       (COUNT(p.id_processo) - COUNT(p.dta_alta)) "Total Processos ativos"
FROM area_atuacao aa,
     processo p
WHERE aa.id_area_atuacao = p.id_area_atuacao
GROUP BY aa.id_area_atuacao, aa.descricao;
/


CREATE OR REPLACE VIEW estatisticas_hospital_view AS
SELECT (SELECT COUNT(1) FROM processo)                                  "Total Processos",
       ((SELECT COUNT(1) FROM processo) - (SELECT COUNT(1)
                                           FROM processo
                                           WHERE dta_alta IS NOT NULL)) "Processos Ativos",
       (SELECT COUNT(1) FROM paciente)                                  "Total Pacientes",
       (SELECT COUNT(DISTINCT pr.nif)
        FROM processo pr
        WHERE pr.dta_alta IS NOT NULL)                                  "Pacientes no hospital",
       (SELECT COUNT(1) FROM enfermeiro)                                "Total Enfermeiros",
       (SELECT COUNT(1) FROM medico)                                    "Total Medicos"
FROM dual;
/


CREATE OR REPLACE VIEW dados_privs_roles_obj_view
AS
SELECT  t.role,
        t.table_name,
        t.privilege
FROM    role_tab_privs t
WHERE
        role IN ('APPLICATION', 'DEVELOPER');
/


CREATE OR REPLACE VIEW dados_privs_roles_sys_view
AS
SELECT  t.role,
        t.privilege
FROM    role_sys_privs t
WHERE
        role IN ('APPLICATION', 'DEVELOPER');
/