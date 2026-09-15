/*========================================================
Atualização das estatísticas do schema
========================================================*/

BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS(
        OWNNAME          => USER,
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE AUTO',
        CASCADE          => TRUE,
        OPTIONS          => 'GATHER AUTO'
    );
END;
/

/*========================================================
Atualização imediata das estatísticas do schema
========================================================*/

BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS(
        OWNNAME          => USER,
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE AUTO',
        CASCADE          => TRUE,
        OPTIONS          => 'GATHER'
    );
END;
/
