CREATE OR REPLACE PROCEDURE internal_delete_all_data_use_at_your_own_risk
IS
    CURSOR cur_user_table_names IS
        SELECT table_name
        FROM user_tables;
    CURSOR cur_user_constraints IS
        SELECT uc.constraint_name, uc.table_name
        FROM user_constraints uc,
             user_tables ut
        WHERE uc.table_name = ut.table_name
        ORDER BY constraint_type; -- Ordenado por constraint_type para criar as restrições de chaves primárias primeiro

    TYPE t_user_constraints_table IS TABLE OF cur_user_constraints%ROWTYPE INDEX BY PLS_INTEGER;
    uc_table t_user_constraints_table;

BEGIN

    OPEN cur_user_constraints;
    FETCH cur_user_constraints BULK COLLECT INTO uc_table;
    CLOSE cur_user_constraints;

    FOR i IN uc_table.first..uc_table.last
        LOOP
            EXECUTE IMMEDIATE 'alter table ' || uc_table(i).table_name || ' disable constraint ' ||
                              uc_table(i).constraint_name || ' CASCADE';
        END LOOP;

    FOR table_name IN cur_user_table_names
        LOOP
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || table_name.table_name || ' CASCADE';
        END LOOP;

    FOR i IN uc_table.first..uc_table.last
        LOOP
            EXECUTE IMMEDIATE 'alter table ' || uc_table(i).table_name || ' enable constraint ' ||
                              uc_table(i).constraint_name || '';
        END LOOP;

    DECLARE
        l_val NUMBER;
    BEGIN
        FOR i IN (SELECT object_name FROM user_objects WHERE object_type = 'SEQUENCE')
            LOOP
                EXECUTE IMMEDIATE
                    'select ' || i.object_name || '.nextval from dual' INTO l_val;

                EXECUTE IMMEDIATE
                        'alter sequence ' || i.object_name || ' increment by -' || l_val ||
                        ' minvalue 0';

                EXECUTE IMMEDIATE
                    'select ' || i.object_name || '.nextval from dual' INTO l_val;

                EXECUTE IMMEDIATE
                    'alter sequence ' || i.object_name || ' increment by 1 minvalue 0';
            END LOOP;
    END;

END;
/

BEGIN
    internal_delete_all_data_use_at_your_own_risk;
END;