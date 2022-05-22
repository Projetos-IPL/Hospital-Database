-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Script para criação de áreas de atuação.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating areas de atuacao...');

INSERT INTO PROJETO.area_atuacao (descricao)
    VALUES ('Unidade do Ombro e Cotovelo');
    
INSERT INTO PROJETO.area_atuacao (descricao)
    VALUES ('Unidade da Anca e Bacia');
    
INSERT INTO PROJETO.area_atuacao (descricao)
    VALUES ('Unidade da Patologia da Coluna Vertebral');
    
INSERT INTO PROJETO.area_atuacao (descricao)
    VALUES ('Unidade de Punho e Mão');
    
INSERT INTO PROJETO.area_atuacao (descricao)
    VALUES ('Unidade de Ortopedia da Criança e do Adolescente');
    
INSERT INTO PROJETO.area_atuacao (descricao)
    VALUES ('Unidade do Joelho e Tibio-Társica, Artroscopia e Traumatologia Desportiva');
    
INSERT INTO PROJETO.area_atuacao (descricao)
    VALUES ('Unidade do Pé e Tornozelo');
    
INSERT INTO PROJETO.area_atuacao (descricao)
    VALUES ('Unidade de Tumores Ósseos e de Partes Moles');

COMMIT;
