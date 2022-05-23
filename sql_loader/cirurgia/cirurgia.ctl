load data into table CIRURGIA
append
fields terminated by ","
(
id_cirurgia, id_processo, id_relatorio, id_tipo_cirurgia, dta_realizacao DATE 'YY.MM.DD'
)
