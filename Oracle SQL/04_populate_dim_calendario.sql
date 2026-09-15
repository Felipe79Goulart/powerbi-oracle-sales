/* ============================================================
   CARGA: DIM_TEMPO

   PERÍODO:
   01/01/2024 até 31/12/2026

   CARACTERÍSTICAS:
   - Português do Brasil
   - Inglês dos Estados Unidos
   - Segunda-feira = 1
   - Domingo = 7
   - Evita duplicidade de datas
   ============================================================ */

INSERT INTO DIM_TEMPO (
    TEMPO_SK,
    DATA_COMPLETA,
    DIA_MES,
    DIA_SEMANA,
    NOME_DIA_SEMANA_PT_BR,
    NOME_DIA_SEMANA_EN_US,
    SEMANA_ANO,
    MES_NUMERO,
    NOME_MES_PT_BR,
    NOME_MES_EN_US,
    TRIMESTRE,
    NOME_TRIMESTRE_PT_BR,
    NOME_TRIMESTRE_EN_US,
    ANO,
    ANO_MES,
    ANO_TRIMESTRE,
    FIM_DE_SEMANA
)
WITH CALENDARIO AS (
    SELECT
        DATE '2024-01-01' + LEVEL - 1 AS DATA_CALENDARIO
    FROM DUAL
    CONNECT BY LEVEL <= (
        DATE '2026-12-31'
        - DATE '2024-01-01'
        + 1
    )
),
ATRIBUTOS_DATA AS (
    SELECT
        DATA_CALENDARIO,

        /* Segunda-feira = 1 e domingo = 7 */
        DATA_CALENDARIO
            - TRUNC(DATA_CALENDARIO, 'IW')
            + 1 AS NUMERO_DIA_SEMANA,

        EXTRACT(
            DAY FROM DATA_CALENDARIO
        ) AS NUMERO_DIA_MES,

        EXTRACT(
            MONTH FROM DATA_CALENDARIO
        ) AS NUMERO_MES,

        EXTRACT(
            YEAR FROM DATA_CALENDARIO
        ) AS NUMERO_ANO,

        TO_NUMBER(
            TO_CHAR(DATA_CALENDARIO, 'IW')
        ) AS NUMERO_SEMANA_ANO,

        TO_NUMBER(
            TO_CHAR(DATA_CALENDARIO, 'Q')
        ) AS NUMERO_TRIMESTRE

    FROM CALENDARIO
)
SELECT
    /* Chave no formato YYYYMMDD */
    TO_NUMBER(
        TO_CHAR(DATA_CALENDARIO, 'YYYYMMDD')
    ) AS TEMPO_SK,

    DATA_CALENDARIO AS DATA_COMPLETA,

    NUMERO_DIA_MES AS DIA_MES,

    NUMERO_DIA_SEMANA AS DIA_SEMANA,

    /* Dia da semana em português */
    CASE NUMERO_DIA_SEMANA
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END AS NOME_DIA_SEMANA_PT_BR,

    /* Dia da semana em inglês */
    CASE NUMERO_DIA_SEMANA
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS NOME_DIA_SEMANA_EN_US,

    NUMERO_SEMANA_ANO AS SEMANA_ANO,

    NUMERO_MES AS MES_NUMERO,

    /* Mês em português */
    CASE NUMERO_MES
        WHEN 1  THEN 'Janeiro'
        WHEN 2  THEN 'Fevereiro'
        WHEN 3  THEN 'Março'
        WHEN 4  THEN 'Abril'
        WHEN 5  THEN 'Maio'
        WHEN 6  THEN 'Junho'
        WHEN 7  THEN 'Julho'
        WHEN 8  THEN 'Agosto'
        WHEN 9  THEN 'Setembro'
        WHEN 10 THEN 'Outubro'
        WHEN 11 THEN 'Novembro'
        WHEN 12 THEN 'Dezembro'
    END AS NOME_MES_PT_BR,

    /* Mês em inglês */
    CASE NUMERO_MES
        WHEN 1  THEN 'January'
        WHEN 2  THEN 'February'
        WHEN 3  THEN 'March'
        WHEN 4  THEN 'April'
        WHEN 5  THEN 'May'
        WHEN 6  THEN 'June'
        WHEN 7  THEN 'July'
        WHEN 8  THEN 'August'
        WHEN 9  THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS NOME_MES_EN_US,

    NUMERO_TRIMESTRE AS TRIMESTRE,

    /* Trimestre em português */
    CASE NUMERO_TRIMESTRE
        WHEN 1 THEN '1º Trimestre'
        WHEN 2 THEN '2º Trimestre'
        WHEN 3 THEN '3º Trimestre'
        WHEN 4 THEN '4º Trimestre'
    END AS NOME_TRIMESTRE_PT_BR,

    /* Trimestre em inglês */
    CASE NUMERO_TRIMESTRE
        WHEN 1 THEN '1st Quarter'
        WHEN 2 THEN '2nd Quarter'
        WHEN 3 THEN '3rd Quarter'
        WHEN 4 THEN '4th Quarter'
    END AS NOME_TRIMESTRE_EN_US,

    NUMERO_ANO AS ANO,

    /* Formato YYYY-MM */
    TO_CHAR(
        DATA_CALENDARIO,
        'YYYY-MM'
    ) AS ANO_MES,

    /* Formato YYYY-QN */
    TO_CHAR(
        DATA_CALENDARIO,
        'YYYY'
    )
    || '-Q'
    || NUMERO_TRIMESTRE AS ANO_TRIMESTRE,

    CASE
        WHEN NUMERO_DIA_SEMANA IN (6, 7)
        THEN 'S'
        ELSE 'N'
    END AS FIM_DE_SEMANA

FROM ATRIBUTOS_DATA A

WHERE NOT EXISTS (
    SELECT 1
    FROM DIM_TEMPO T
    WHERE T.DATA_COMPLETA = A.DATA_CALENDARIO
);

COMMIT;
