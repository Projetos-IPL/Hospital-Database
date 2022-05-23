load data into table PESSOA
append
fields terminated by ","
(
nif, prim_nome, ult_nome, morada, dta_nasc DATE 'YY.MM.DD'
)
