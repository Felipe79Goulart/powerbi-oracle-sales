/* ============================================================
   CRIAÇÃO IDEMPOTENTE DOS ÍNDICES
   TABELA: FATO_VENDAS
   ============================================================ */

DECLARE
    PROCEDURE CRIAR_INDICE (
        P_NOME_INDICE VARCHAR2,
        P_COMANDO_SQL VARCHAR2
    )
    IS
        V_QUANTIDADE NUMBER;
    BEGIN
        SELECT COUNT(*)
          INTO V_QUANTIDADE
          FROM USER_INDEXES
         WHERE INDEX_NAME = UPPER(P_NOME_INDICE);

        IF V_QUANTIDADE = 0 THEN
            EXECUTE IMMEDIATE P_COMANDO_SQL;

            DBMS_OUTPUT.PUT_LINE(
                'Índice criado: ' || P_NOME_INDICE
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Índice já existente: ' || P_NOME_INDICE
            );
        END IF;
    END;
BEGIN
    /* Filtros e agrupamentos por período e status */
    CRIAR_INDICE(
        'IX_FV_TEMPO_STATUS',
        'CREATE INDEX IX_FV_TEMPO_STATUS
         ON FATO_VENDAS (TEMPO_SK, STATUS_VENDA_SK)'
    );

    /* Análises de clientes ao longo do tempo */
    CRIAR_INDICE(
        'IX_FV_CLIENTE_TEMPO',
        'CREATE INDEX IX_FV_CLIENTE_TEMPO
         ON FATO_VENDAS (CLIENTE_SK, TEMPO_SK)'
    );

    /* Análises de produtos ao longo do tempo */
    CRIAR_INDICE(
        'IX_FV_PRODUTO_TEMPO',
        'CREATE INDEX IX_FV_PRODUTO_TEMPO
         ON FATO_VENDAS (PRODUTO_SK, TEMPO_SK)'
    );

    /* Análises de vendedores ao longo do tempo */
    CRIAR_INDICE(
        'IX_FV_VENDEDOR_TEMPO',
        'CREATE INDEX IX_FV_VENDEDOR_TEMPO
         ON FATO_VENDAS (VENDEDOR_SK, TEMPO_SK)'
    );

    /* Análises de canais ao longo do tempo */
    CRIAR_INDICE(
        'IX_FV_CANAL_TEMPO',
        'CREATE INDEX IX_FV_CANAL_TEMPO
         ON FATO_VENDAS (CANAL_SK, TEMPO_SK)'
    );

    /* Filtros que começam pelo status */
    CRIAR_INDICE(
        'IX_FV_STATUS_TEMPO',
        'CREATE INDEX IX_FV_STATUS_TEMPO
         ON FATO_VENDAS (STATUS_VENDA_SK, TEMPO_SK)'
    );
END;
/
