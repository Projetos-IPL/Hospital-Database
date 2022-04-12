/*
********************************************************

    DEFINIÇÃO DE TRIGGERS

    Afonso Santos, Iúri Raimundo
    Deloitte Delivery Center S.A - Brightstart

*********************************************************
*/


CREATE OR REPLACE TRIGGER tbi_seq_area_atuacao BEFORE
    INSERT ON area_atuacao
    FOR EACH ROW
BEGIN
    :new.id_area_atuacao := pk_area_atuacao_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_cirurgia BEFORE
    INSERT ON cirurgia
    FOR EACH ROW
BEGIN
    :new.id_cirurgia := pk_cirurgia_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_consulta BEFORE
    INSERT ON consulta
    FOR EACH ROW
BEGIN
    :new.id_consulta := pk_consulta_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_relatorio BEFORE
    INSERT ON relatorio
    FOR EACH ROW
BEGIN
    :new.id_relatorio := pk_relatorio_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_tipo_cirurgia BEFORE
    INSERT ON tipo_cirurgia
    FOR EACH ROW
BEGIN
    :new.id_tipo_cirurgia := pk_tipo_cirurgia_seq.nextval;
END;
/

CREATE OR REPLACE TRIGGER tbi_seq_tratamento BEFORE
    INSERT ON tratamento
    FOR EACH ROW
BEGIN
    :new.id_tratamento := pk_tratamento_seq.nextval;
END;
/