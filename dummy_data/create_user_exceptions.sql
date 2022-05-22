-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Script para criação de exceções.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating user exceptions...');


BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE user_exception';

    exception_handler.add_user_exception(
            -20001,
            'exception_not_defined',
            'Exceção não definida.');

    exception_handler.add_user_exception(
            -20002,
            'system_exception',
            'Exceção de sistema ou genérica acionada no "EXCEPTION WHEN OTHERS THEN ..."');

    exception_handler.add_user_exception(
            -20799,
            'consulta_em_processo_finalizado',
            'Tentativa de registo de consulta em processo já finalizado.');

    exception_handler.add_user_exception(
            -20798,
            'alteracao_consulta',
            'Tentativa de alteração de consulta.');

    exception_handler.add_user_exception(
            -20899,
            'menor_de_idade',
            'Não é permitido o registo de pessoas com menos de 18 anos.' );

    exception_handler.add_user_exception(
            -20888,
            'paciente_sem_processo',
            'Paciente sem processo registado.');

    exception_handler.add_user_exception(
            -20887,
            'nome_invalido',
            'Nome da pessoa inválido. O nome não pode conter números ou carateres especiais' );

    exception_handler.add_user_exception(
            -20699,
            'alteracao_relatorio',
            'Tentativa de alteração de um relatório.');

    exception_handler.add_user_exception(
            -20998,
            'processo_repetido',
            'Tentativa de abertura de processo repetido para o mesmo paciente.');

    exception_handler.add_user_exception(
            -20997,
            'processo_nao_encontrado',
            'processo não encontrado.');

    exception_handler.add_user_exception(
            -20996,
            'processo_ja_finalizado',
            'Tentativa de finalizar processo já finalizado.');

    exception_handler.add_user_exception(
            -20995,
            'alteracao_processo_invalida',
            'Tentativa de alteração do processo não permitida.');

    exception_handler.add_user_exception(
            -20101,
            'excecao_mal_formatada',
            'Nome/código de exceção mal formatada.');

    exception_handler.add_user_exception(
            -20500,
            'area_atuacao_nao_corresponde',
            'Área de atuação não corresponde!');

    exception_handler.add_user_exception(
            -20501,
            'alteracao_cirurgia',
            'Alteração/remoção de uma cirurgia não permitida!');

    exception_handler.add_user_exception(
        -20502,
        'cirurgia_em_processo_finalizado',
        'Tentativa de registo de consulta em processo já finalizado.');
END;
/
