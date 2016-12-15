WITH cal_base
     AS (SELECT LAST_DAY (:SYS_DATE) LAST_DAY,
                TO_CHAR (LAST_DAY (:SYS_DATE), 'dd') no_of_days,
                LAST_DAY (:SYS_DATE) - (TO_CHAR (LAST_DAY (:SYS_DATE), 'dd') - 1)
                   first_day,
                TO_CHAR (
                   LAST_DAY (:SYS_DATE)
                   - (TO_CHAR (LAST_DAY (:SYS_DATE), 'dd') - 1),
                   'D')
                   first_weekday,
                CEIL (
                   (TO_CHAR (LAST_DAY (:SYS_DATE), 'dd')
                    + TO_CHAR (
                         LAST_DAY (:SYS_DATE)
                         - (TO_CHAR (LAST_DAY (:SYS_DATE), 'dd') - 1),
                         'D')
                    - 1)
                   / 7)
                   no_of_weeks
           FROM DUAL)
    SELECT CASE
              WHEN 1 + (7 * (LEVEL - 1)) - (first_weekday - 1) < 1
                   OR 1 + (7 * (LEVEL - 1)) - (first_weekday - 1) > no_of_days
              THEN
                 NULL
              ELSE
                 1 + (7 * (LEVEL - 1)) - (first_weekday - 1)
           END
              Sun,
           CASE
              WHEN 2 + (7 * (LEVEL - 1)) - (first_weekday - 1) < 1
                   OR 2 + (7 * (LEVEL - 1)) - (first_weekday - 1) > no_of_days
              THEN
                 NULL
              ELSE
                 2 + (7 * (LEVEL - 1)) - (first_weekday - 1)
           END
              Mon,
           CASE
              WHEN 3 + (7 * (LEVEL - 1)) - (first_weekday - 1) < 1
                   OR 3 + (7 * (LEVEL - 1)) - (first_weekday - 1) > no_of_days
              THEN
                 NULL
              ELSE
                 3 + (7 * (LEVEL - 1)) - (first_weekday - 1)
           END
              Tue,
           CASE
              WHEN 4 + (7 * (LEVEL - 1)) - (first_weekday - 1) < 1
                   OR 4 + (7 * (LEVEL - 1)) - (first_weekday - 1) > no_of_days
              THEN
                 NULL
              ELSE
                 4 + (7 * (LEVEL - 1)) - (first_weekday - 1)
           END
              Wed,
           CASE
              WHEN 5 + (7 * (LEVEL - 1)) - (first_weekday - 1) < 1
                   OR 5 + (7 * (LEVEL - 1)) - (first_weekday - 1) > no_of_days
              THEN
                 NULL
              ELSE
                 5 + (7 * (LEVEL - 1)) - (first_weekday - 1)
           END
              Thu,
           CASE
              WHEN 6 + (7 * (LEVEL - 1)) - (first_weekday - 1) < 1
                   OR 6 + (7 * (LEVEL - 1)) - (first_weekday - 1) > no_of_days
              THEN
                 NULL
              ELSE
                 6 + (7 * (LEVEL - 1)) - (first_weekday - 1)
           END
              Fri,
           CASE
              WHEN 7 + (7 * (LEVEL - 1)) - (first_weekday - 1) < 1
                   OR 7 + (7 * (LEVEL - 1)) - (first_weekday - 1) > no_of_days
              THEN
                 NULL
              ELSE
                 7 + (7 * (LEVEL - 1)) - (first_weekday - 1)
           END
              Sat
      FROM cal_base
CONNECT BY LEVEL <= no_of_weeks