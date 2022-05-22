-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Cabeçalho do pacote ENCRYPTION_UTILS


CREATE OR REPLACE PACKAGE encryption_utils AS

	FUNCTION encrypt_str (p_str IN VARCHAR2) RETURN RAW DETERMINISTIC;

	FUNCTION decrypt_str (p_str IN VARCHAR2) RETURN VARCHAR2 DETERMINISTIC;

END encryption_utils;
/