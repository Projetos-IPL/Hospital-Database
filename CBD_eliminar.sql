-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para apagar objetos da base de dados

DROP TABLE medico_cirurgia;
/

DROP TABLE cirurgia;
/

DROP TABLE consulta;
/

DROP TABLE processo;
/

DROP TABLE relatorio;
/

DROP TABLE enfermeiro;
/

DROP TABLE medico;
/

DROP TABLE funcionario;
/

DROP TABLE paciente;
/

DROP TABLE pessoa;
/

DROP TABLE estado_paciente;
/

DROP TABLE tipo_cirurgia;
/

DROP TABLE area_atuacao;
/

DROP TABLE user_exception;
/

DROP TABLE exception_log;
/

DROP SEQUENCE pk_area_atuacao_seq;
/

DROP SEQUENCE pk_relatorio_seq;
/

DROP SEQUENCE pk_processo_seq;
/

DROP SEQUENCE pk_tipo_cirurgia_seq;
/

DROP SEQUENCE pk_cirurgia_seq;
/

DROP SEQUENCE pk_consulta_seq;
/

DROP SEQUENCE pk_estado_paciente_seq;
/

DROP SEQUENCE pk_exception_log_seq;
/

DROP VIEW processo_dados_view;
/

DROP PACKAGE et_consulta;
/

DROP PACKAGE et_relatorio;
/

DROP PACKAGE et_pessoa;
/

DROP PACKAGE et_processo;
/

DROP PACKAGE et_cirurgia;
/

DROP PACKAGE exception_handler;
/

COMMIT;