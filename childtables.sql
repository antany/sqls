-- Used to Identify all the child tables and the column name used for parent child relationship

SELECT SYS_CONNECT_BY_PATH (UCC.TABLE_NAME || '(' || COLUMN_NAME || ')',
                                '-->')
              PATH,
           LEVEL
      FROM user_constraints uc,
           (    SELECT table_name,
                       CONSTRAINT_NAME,
                       MAX (LTRIM (SYS_CONNECT_BY_PATH (column_name, ','), ','))
                          column_name
                  FROM (SELECT table_name,
                               constraint_name,
                               column_name,
                               RANK ()
                               OVER (PARTITION BY constraint_name
                                     ORDER BY column_name)
                                  rnk
                          FROM user_cons_columns ucc)
            START WITH rnk = 1
            CONNECT BY PRIOR rnk = rnk - 1
                       AND PRIOR constraint_name = constraint_name
              GROUP BY table_name, constraint_name) ucc
     WHERE uc.constraint_name = ucc.constraint_name
START WITH uc.table_name = 'TABLE_NAME' AND constraint_type = 'P'
CONNECT BY NOCYCLE PRIOR uc.CONSTRAINT_NAME = r_CONSTRAINT_NAME
                   OR (PRIOR uc.table_name = uc.table_name
                       AND uc.constraint_type = 'P')
  ORDER BY 1;