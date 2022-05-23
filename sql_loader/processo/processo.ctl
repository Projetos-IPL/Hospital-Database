load data into table PROCESSO
append
fields terminated by ","
(
id_processo, nif, id_area_atuacao, id_estado_paciente, dta_inicio DATE 'YY.MM.DD', dta_alta DATE 'YY.MM.DD' NULLIF dta_alta = 'NULL'
)
