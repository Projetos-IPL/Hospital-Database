-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: objetos relacionados com encriptação


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating encryption...');

INSERT INTO PROJETO.encryption_key (key) VALUES ('1234567890999899');

COMMIT;
