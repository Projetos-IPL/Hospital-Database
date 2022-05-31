-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: script para criação de roles e atribuição de privilégios


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating roles...');


-- remove roles if exist
DROP ROLE developer;
DROP ROLE application;
DROP ROLE manager;

-- create roles
CREATE ROLE developer;
CREATE ROLE application;
CREATE ROLE manager;

DECLARE
	schema_name VARCHAR2(100) := 'PROJETO';
	TYPE t_varchar2 IS TABLE OF VARCHAR2(100);

    debug_current_iteration VARCHAR2(100);

    t_developer_allowed_packages t_varchar2 := t_varchar2('et_pessoa', 'et_cirurgia', 'et_consulta', 'et_processo', 'et_relatorio', 'exception_handler');
    t_developer_allowed_views    t_varchar2 := t_varchar2('dados_paciente_view', 'medico_area_atuacao_view', 'processo_dados_view', 'processo_total_consultas_view', 'processos_ativos_view');
    t_developer_allowed_tables   t_varchar2 := t_varchar2('area_atuacao', 'cirurgia', 'consulta', 'enfermeiro', 'estado_paciente', 'exception_log', 'funcionario', 'medico', 'medico_cirurgia', 'paciente', 'pessoa', 'processo', 'relatorio', 'telefone', 'tipo_cirurgia', 'user_exception');
    t_developer_privileges       t_varchar2 := t_varchar2('CREATE SESSION', 'CREATE TABLE', 'UPDATE ANY TABLE', 'CREATE SEQUENCE', 'CREATE ANY PROCEDURE', 'CREATE ANY MATERIALIZED VIEW');

    t_application_allowed_packages t_varchar2 := t_varchar2('et_pessoa', 'et_cirurgia', 'et_consulta', 'et_processo', 'et_relatorio');
    t_application_allowed_views    t_varchar2 := t_varchar2('dados_paciente_view', 'medico_area_atuacao_view', 'processo_dados_view', 'processo_total_consultas_view', 'processos_ativos_view');
    t_application_privileges       t_varchar2 := t_varchar2('CREATE SESSION');

		t_manager_allowed_packages     t_varchar2 := t_varchar2('et_pessoa', 'et_cirurgia', 'et_consulta', 'et_processo', 'et_relatorio');
		t_manager_allowed_views        t_varchar2 := t_varchar2('dados_paciente_view', 'medico_area_atuacao_view', 'processo_dados_view', 'processo_total_consultas_view', 'processos_ativos_view', 'dados_moradas_pessoas_view');
		t_manager_privileges					 t_varchar2 := t_varchar2('CREATE SESSION');

    PROCEDURE grantCommandOnObjectsToRole(p_command IN VARCHAR2, p_objects IN t_varchar2, p_role IN VARCHAR2) IS
    BEGIN
        FOR i IN p_objects.FIRST..p_objects.LAST
        LOOP
            debug_current_iteration := 'GRANT ' || p_command || ' ON ' || p_objects(i) || ' TO ' || p_role;
            EXECUTE IMMEDIATE 'GRANT ' || p_command || ' ON ' || p_objects(i) || ' TO ' || p_role;
        END LOOP;
    END;

		CONN / AS SYSDBA

    PROCEDURE grantPrivilegeToRole(p_privileges IN t_varchar2, p_role IN VARCHAR2) IS
    BEGIN
        FOR i IN p_privileges.FIRST..p_privileges.LAST
        LOOP
            debug_current_iteration := p_privileges(i);
            EXECUTE IMMEDIATE 'GRANT ' || p_privileges(i) || ' TO ' || p_role;
        END LOOP;
    END;

		CONN PROJETO/Projeto_22

BEGIN
    -- Developer grants
    -- Packages
    grantCommandOnObjectsToRole('EXECUTE', t_developer_allowed_packages, 'developer');
    -- Tables
    grantCommandOnObjectsToRole('SELECT', t_developer_allowed_tables, 'developer');
    grantCommandOnObjectsToRole('UPDATE', t_developer_allowed_tables, 'developer');
    grantCommandOnObjectsToRole('DELETE', t_developer_allowed_tables, 'developer');
    grantCommandOnObjectsToRole('INSERT', t_developer_allowed_tables, 'developer');
    -- Views
    grantCommandOnObjectsToRole('SELECT', t_developer_allowed_views, 'developer');
    -- Privilege
    grantPrivilegeToRole(t_developer_privileges, 'developer');

    -- Application grants
    -- Package
    grantCommandOnObjectsToRole('EXECUTE',  t_application_allowed_packages, 'application');
    -- Views
    grantCommandOnObjectsToRole('SELECT', t_application_allowed_views, 'application');
    -- Privileges
    grantPrivilegeToRole(t_application_privileges, 'application');

		-- Manager grants
    -- Package
    grantCommandOnObjectsToRole('EXECUTE',  t_manager_allowed_packages, 'manager');
    -- Views
    grantCommandOnObjectsToRole('SELECT', t_manager_allowed_views, 'manager');
    -- Privileges
    grantPrivilegeToRole(t_manager_privileges, 'manager');

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(debug_current_iteration);
            RAISE_APPLICATION_ERROR(-20500, SQLERRM);
END;
/