CREATE OR REPLACE TRIGGER tbi_seq_area_atuacao BEFORE
    INSERT ON area_atuacao
    FOR EACH ROW
BEGIN
    :NEW.id_area_atuacao := pk_area_atuacao_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_cirurgia BEFORE
    INSERT ON cirurgia
    FOR EACH ROW
BEGIN
    :NEW.id_cirurgia := pk_cirurgia_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_consulta BEFORE
    INSERT ON consulta
    FOR EACH ROW
BEGIN
    :NEW.id_consulta := pk_consulta_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_relatorio BEFORE
    INSERT ON relatorio
    FOR EACH ROW
BEGIN
    :NEW.id_relatorio := pk_relatorio_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_tipo_cirurgia BEFORE
    INSERT ON tipo_cirurgia
    FOR EACH ROW
BEGIN
    :NEW.id_tipo_cirurgia := pk_tipo_cirurgia_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_tratamento BEFORE
    INSERT ON tratamento
    FOR EACH ROW
BEGIN
    :NEW.id_tratamento := pk_tratamento_seq.NEXTVAL;
END;
/

COMMIT;
      