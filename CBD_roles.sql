CREATE ROLE developer;
CREATE ROLE application;

DECLARE
		schema_name VARCHAR2(100) := 'PROJETO';
		TYPE t_varchar2 IS TABLE OF VARCHAR2(100);

    debug_current_iteration VARCHAR2(100);

    t_developer_allowed_packages t_varchar2 := t_varchar2('et_pessoa', 'et_cirurgia', 'et_consulta', 'et_processo', 'et_relatorio', 'exception_handler');
    t_developer_allowed_views    t_varchar2;
    t_developer_allowed_tables   t_varchar2;
    t_developer_privileges       t_varchar2 := t_varchar2('CREATE SESSION', 'CREATE TABLE', 'UPDATE ANY TABLE', 'CREATE SEQUENCE', 'CREATE ANY PROCEDURE', 'CREATE ANY MATERIALIZED VIEW');

    CURSOR cur_schema_tables(p_schema VARCHAR2) IS
        SELECT table_name
            FROM all_tables
            WHERE owner = UPPER(p_schema);

    CURSOR cur_schema_views(p_schema VARCHAR2) IS
        SELECT view_name
            FROM all_views_ae
            WHERE owner = UPPER(p_schema);

    t_application_allowed_packages t_varchar2 := t_varchar2('et_pessoa', 'et_cirurgia', 'et_consulta', 'et_processo', 'et_relatorio');
    t_application_allowed_views    t_varchar2 := t_varchar2('dados_paciente_view', 'medico_area_atuacao_view', 'processo_dados_view', 'processo_total_consultas_view', 'processos_ativos_view');
    t_application_privileges      t_varchar2 := t_varchar2('CREATE SESSION');

    PROCEDURE grantCommandOnObjectsToRole(p_command IN VARCHAR2, p_objects IN t_varchar2, p_role IN VARCHAR2) IS
    BEGIN
        FOR i IN p_objects.FIRST..p_objects.LAST
        LOOP
            debug_current_iteration := 'GRANT ' || p_command || ' ON ' || p_objects(i) || ' TO ' || p_role;
            EXECUTE IMMEDIATE 'GRANT ' || p_command || ' ON ' || p_objects(i) || ' TO ' || p_role;
        END LOOP;
    END;

    PROCEDURE grantPrivilegeToRole(p_privileges IN t_varchar2, p_role IN VARCHAR2) IS
    BEGIN
        FOR i IN p_privileges.FIRST..p_privileges.LAST
        LOOP
            debug_current_iteration := p_privileges(i);
            EXECUTE IMMEDIATE 'GRANT ' || p_privileges(i) || ' TO ' || p_role;
        END LOOP;
    END;

BEGIN
    -- Developer grants
    -- Packages
    grantCommandOnObjectsToRole('EXECUTE', t_developer_allowed_packages, 'developer');
    -- Tables
    OPEN cur_schema_tables(:schema_name);
        FETCH cur_schema_tables BULK COLLECT INTO t_developer_allowed_tables;
    CLOSE cur_schema_tables;
    grantCommandOnObjectsToRole('SELECT', t_developer_allowed_tables, 'developer');
    grantCommandOnObjectsToRole('UPDATE', t_developer_allowed_tables, 'developer');
    grantCommandOnObjectsToRole('DELETE', t_developer_allowed_tables, 'developer');
    grantCommandOnObjectsToRole('INSERT', t_developer_allowed_tables, 'developer');
    -- Views
    OPEN cur_schema_views(:schema_name);
        FETCH cur_schema_views BULK COLLECT INTO t_developer_allowed_views;
    CLOSE cur_schema_views;
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

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(debug_current_iteration);
            RAISE_APPLICATION_ERROR(-20500, SQLERRM);
END;
/