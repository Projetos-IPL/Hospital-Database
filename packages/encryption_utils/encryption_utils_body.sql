-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Corpo do pacote ENCRYPTION_UTILS


CREATE OR REPLACE PACKAGE BODY encryption_utils AS

	FUNCTION get_encryption_key
		RETURN VARCHAR2 DETERMINISTIC
	AS
		v_key VARCHAR2(200);
		CURSOR cur_key IS
			SELECT key FROM PROJETO.encryption_key;
	BEGIN
		OPEN cur_key;
		FETCH cur_key INTO v_key;
		CLOSE cur_key;

		RETURN v_key;
	END get_encryption_key;


	FUNCTION encrypt_str
		(p_str IN VARCHAR2)
		RETURN RAW DETERMINISTIC
	AS
		v_key VARCHAR2(200);
		n_mod NUMBER
			:=	dbms_crypto.encrypt_aes128
				+ dbms_crypto.chain_cbc
				+ dbms_crypto.pad_pkcs5;
		r_encrypted_raw        	RAW (2000);
		r_return 								RAW (2000);
	BEGIN
		v_key := get_encryption_key();

		r_encrypted_raw :=
			dbms_crypto.encrypt(
				utl_i18n.string_to_raw(p_str, 'AL32UTF8'),
				n_mod,
				utl_i18n.string_to_raw (v_key, 'AL32UTF8')
			);

		RETURN r_encrypted_raw;
	END encrypt_str;


	FUNCTION decrypt_str
		(p_str IN VARCHAR2)
		RETURN VARCHAR2 DETERMINISTIC
	AS
		v_key VARCHAR2(200);
		n_mod NUMBER
			:=	dbms_crypto.encrypt_aes128
				+ dbms_crypto.chain_cbc
				+ dbms_crypto.pad_pkcs5;
		r_decrypted_raw        	RAW (5000);
		r_return 								VARCHAR2 (5000);
	BEGIN
		v_key := get_encryption_key();

		r_decrypted_raw :=
			dbms_crypto.decrypt(
				p_str,
				n_mod,
				utl_i18n.string_to_raw(v_key, 'AL32UTF8')
			);
		
		r_return := utl_i18n.raw_to_char(r_decrypted_raw);

		RETURN r_return;
	END decrypt_str;

END encryption_utils;
/