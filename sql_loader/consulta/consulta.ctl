load data into table CONSULTA
append
fields terminated by ","
(
id_consulta, id_processo, nif_funcionario, id_relatorio, id_estado_paciente, dta_realizacao DATE 'YY.MM.DD'
)
