-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script principal para criação dos objetos.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Starting main script...');

SPOOL /hospital_database.log


-- User and schema
@@ CBD_schema.sql

@@ CBD_tablespaces.sql
@@ CBD_tabelas.sql
@@ CBD_sequences.sql

-- Exception handling package
@@ exception_handler.sql
@@ exception_handler_body.sql

-- Encryption utils and key
@@ encryption_utils.sql
@@ encryption_utils_body.sql
@@ CBD_encryption.sql

-- Package header
@@ et_pessoa.sql
@@ et_processo.sql
@@ et_cirurgia.sql
@@ et_consulta.sql
@@ et_relatorio.sql

-- Views
@@ CBD_views.sql

-- Package body
@@ et_cirurgia_body.sql
@@ et_consulta_body.sql
@@ et_pessoa_body.sql
@@ et_relatorio_body.sql
@@ et_processo_body.sql

@@ CBD_triggers.sql

-- Dummy data
@@ create_user_exceptions.sql
@@ create_areas_atuacao.sql
@@ create_tipos_cirurgias.sql
@@ create_estados_pacientes.sql
@@ create_pessoas.sql
@@ create_cirurgias.sql
@@ create_consultas.sql

@@ CBD_roles.sql
@@ CBD_audit.sql
@@ CBD_indices.sql


EXECUTE dbms_output.put_line('> Tudo criado!');

SPOOL OFF