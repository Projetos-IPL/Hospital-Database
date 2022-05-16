-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Script para criação de estados de pacientes.

INSERT INTO estado_paciente (descricao)
    VALUES ('Cuidados Mínimos');

INSERT INTO estado_paciente (descricao)
    VALUES ('Cuidados Intermediários');

INSERT INTO estado_paciente (descricao)
    VALUES ('Cuidados Semi-Intensivos');

INSERT INTO estado_paciente (descricao)
    VALUES ('Cuidados Intensivos');

COMMIT;