/* ============================================================
   CARGA: FATO_VENDAS

   GRANULARIDADE:
   Uma linha para cada item vendido dentro de um pedido.

   QUANTIDADE:
   20.000 itens.
   Aproximadamente 6.667 pedidos.

   PERÍODO:
   01/01/2024 até 14/09/2026.

   CARACTERÍSTICAS:
   - Chaves buscadas nas dimensões;
   - Nenhuma chave substituta é presumida;
   - Dados determinísticos;
   - Carga protegida contra duplicidade;
   - Atributos do pedido permanecem iguais em todos os itens.
   ============================================================ */

INSERT INTO FATO_VENDAS (
    PEDIDO_ID,
    ITEM_PEDIDO,
    TEMPO_SK,
    CLIENTE_SK,
    PRODUTO_SK,
    VENDEDOR_SK,
    CANAL_SK,
    STATUS_VENDA_SK,
    QUANTIDADE,
    PRECO_UNITARIO,
    DESCONTO_PCT,
    VALOR_BRUTO,
    VALOR_DESCONTO,
    VALOR_LIQUIDO,
    CUSTO_TOTAL,
    LUCRO
)
WITH
/* ============================================================
   1. Parâmetros da carga
   ============================================================ */
PARAMETROS AS (
    SELECT
        DATE '2024-01-01' AS DATA_INICIAL,
        DATE '2026-09-14' AS DATA_FINAL,
        20000 AS QUANTIDADE_ITENS
    FROM DUAL
),

/* ============================================================
   2. Geração dos 20.000 itens
   ============================================================ */
ITENS_NUMERADOS AS (
    SELECT
        LEVEL AS NUMERO_ITEM_GERAL
    FROM DUAL
    CONNECT BY LEVEL <= 20000
),

/* ============================================================
   3. Definição dos itens e pedidos

   Cada pedido possui até três itens:
   Itens 1, 2 e 3   -> pedido 1
   Itens 4, 5 e 6   -> pedido 2
   ============================================================ */
ITENS_BASE AS (
    SELECT
        NUMERO_ITEM_GERAL,

        CEIL(
            NUMERO_ITEM_GERAL / 3
        ) AS NUMERO_PEDIDO,

        MOD(
            NUMERO_ITEM_GERAL - 1,
            3
        ) + 1 AS ITEM_PEDIDO,

        MOD(
            (NUMERO_ITEM_GERAL * 11) - 1,
            10
        ) + 1 AS QUANTIDADE,

        CASE MOD(NUMERO_ITEM_GERAL, 10)
            WHEN 0 THEN 15
            WHEN 1 THEN 10
            WHEN 2 THEN 5
            WHEN 3 THEN 5
            ELSE 0
        END AS DESCONTO_PCT,

        CASE MOD(NUMERO_ITEM_GERAL, 5)
            WHEN 0 THEN 0.98
            WHEN 1 THEN 1.00
            WHEN 2 THEN 0.97
            WHEN 3 THEN 1.02
            ELSE 0.95
        END AS FATOR_PRECO

    FROM ITENS_NUMERADOS
),

/* ============================================================
   4. Geração dos 6.667 pedidos
   ============================================================ */
PEDIDOS_NUMERADOS AS (
    SELECT
        LEVEL AS NUMERO_PEDIDO
    FROM DUAL
    CONNECT BY LEVEL <= 6667
),

/* ============================================================
   5. Atributos no nível do pedido

   Data, cliente, vendedor, canal e status serão definidos
   no nível do pedido, e não no nível do item.
   ============================================================ */
PEDIDOS_BASE AS (
    SELECT
        P.NUMERO_PEDIDO,

        'PED'
        || LPAD(
            TO_CHAR(P.NUMERO_PEDIDO),
            8,
            '0'
        ) AS PEDIDO_ID,

        PA.DATA_INICIAL
        + MOD(
            (P.NUMERO_PEDIDO * 37)
            + TRUNC(P.NUMERO_PEDIDO / 13),
            PA.DATA_FINAL
            - PA.DATA_INICIAL
            + 1
        ) AS DATA_VENDA,

        /* Distribuição aproximada:
           75% entregues
           17% faturados
            5% devolvidos
            3% cancelados */
        CASE
            WHEN MOD(P.NUMERO_PEDIDO, 100)
                 BETWEEN 0 AND 2
            THEN 'CANCELLED'

            WHEN MOD(P.NUMERO_PEDIDO, 100)
                 BETWEEN 3 AND 7
            THEN 'RETURNED'

            WHEN MOD(P.NUMERO_PEDIDO, 100)
                 BETWEEN 8 AND 24
            THEN 'INVOICED'

            ELSE 'DELIVERED'
        END AS STATUS_VENDA_CODIGO

    FROM PEDIDOS_NUMERADOS P
    CROSS JOIN PARAMETROS PA
),

/* ============================================================
   6. Clientes elegíveis para cada pedido

   O cliente somente pode receber uma venda em data igual ou
   posterior à sua data de cadastro.
   ============================================================ */
CLIENTES_CANDIDATOS AS (
    SELECT
        P.NUMERO_PEDIDO,
        C.CLIENTE_SK,
        C.CLIENTE_ID,

        ROW_NUMBER() OVER (
            PARTITION BY P.NUMERO_PEDIDO
            ORDER BY C.CLIENTE_ID
        ) AS NUMERO_CLIENTE,

        COUNT(*) OVER (
            PARTITION BY P.NUMERO_PEDIDO
        ) AS TOTAL_CLIENTES_ELEGIVEIS

    FROM PEDIDOS_BASE P

    INNER JOIN DIM_CLIENTE C
        ON C.ATIVO = 'S'
       AND C.REGISTRO_ATUAL = 'S'
       AND (
            C.DATA_CADASTRO IS NULL
            OR TRUNC(C.DATA_CADASTRO) <= P.DATA_VENDA
       )
),

/* ============================================================
   7. Escolha de um cliente elegível por pedido
   ============================================================ */
CLIENTES_ESCOLHIDOS AS (
    SELECT
        NUMERO_PEDIDO,
        CLIENTE_SK
    FROM CLIENTES_CANDIDATOS
    WHERE NUMERO_CLIENTE =
        MOD(
            (NUMERO_PEDIDO * 13) - 1,
            TOTAL_CLIENTES_ELEGIVEIS
        ) + 1
),

/* ============================================================
   8. Enumeração dos produtos ativos

   Isso permite usar as chaves existentes, mesmo que a
   PRODUTO_SK não comece em 1 ou possua lacunas.
   ============================================================ */
PRODUTOS_ENUMERADOS AS (
    SELECT
        PRODUTO_SK,
        PRODUTO_ID,
        PRECO_LISTA,
        CUSTO_PADRAO,

        ROW_NUMBER() OVER (
            ORDER BY PRODUTO_ID
        ) AS NUMERO_PRODUTO,

        COUNT(*) OVER () AS TOTAL_PRODUTOS

    FROM DIM_PRODUTO
    WHERE ATIVO = 'S'
      AND REGISTRO_ATUAL = 'S'
),

/* ============================================================
   9. Enumeração dos vendedores ativos
   ============================================================ */
VENDEDORES_ENUMERADOS AS (
    SELECT
        VENDEDOR_SK,
        VENDEDOR_ID,

        ROW_NUMBER() OVER (
            ORDER BY VENDEDOR_ID
        ) AS NUMERO_VENDEDOR,

        COUNT(*) OVER () AS TOTAL_VENDEDORES

    FROM DIM_VENDEDOR
    WHERE ATIVO = 'S'
),

/* ============================================================
   10. Enumeração dos canais ativos

   A DIM_CANAL possui chaves de 2 a 6, mas isso não causa
   problemas porque as chaves são obtidas nesta consulta.
   ============================================================ */
CANAIS_ENUMERADOS AS (
    SELECT
        CANAL_SK,
        CANAL_ID,

        ROW_NUMBER() OVER (
            ORDER BY CANAL_ID
        ) AS NUMERO_CANAL,

        COUNT(*) OVER () AS TOTAL_CANAIS

    FROM DIM_CANAL
    WHERE ATIVO = 'S'
),

/* ============================================================
   11. Associação dos pedidos às dimensões

   Cliente, data, vendedor, canal e status são definidos uma
   única vez para cada pedido.
   ============================================================ */
PEDIDOS_DIMENSIONADOS AS (
    SELECT
        P.NUMERO_PEDIDO,
        P.PEDIDO_ID,
        P.DATA_VENDA,

        T.TEMPO_SK,
        C.CLIENTE_SK,
        V.VENDEDOR_SK,
        CA.CANAL_SK,
        S.STATUS_VENDA_SK

    FROM PEDIDOS_BASE P

    INNER JOIN DIM_TEMPO T
        ON T.DATA_COMPLETA = P.DATA_VENDA

    INNER JOIN CLIENTES_ESCOLHIDOS C
        ON C.NUMERO_PEDIDO = P.NUMERO_PEDIDO

    INNER JOIN VENDEDORES_ENUMERADOS V
        ON V.NUMERO_VENDEDOR =
            MOD(
                (P.NUMERO_PEDIDO * 5) - 1,
                V.TOTAL_VENDEDORES
            ) + 1

    INNER JOIN CANAIS_ENUMERADOS CA
        ON CA.NUMERO_CANAL =
            MOD(
                (P.NUMERO_PEDIDO * 3) - 1,
                CA.TOTAL_CANAIS
            ) + 1

    INNER JOIN DIM_STATUS_VENDA S
        ON S.STATUS_VENDA_CODIGO =
            P.STATUS_VENDA_CODIGO
       AND S.ATIVO = 'S'
),

/* ============================================================
   12. Associação dos produtos aos itens
   ============================================================ */
ITENS_DIMENSIONADOS AS (
    SELECT
        I.NUMERO_ITEM_GERAL,
        I.ITEM_PEDIDO,
        I.QUANTIDADE,
        I.DESCONTO_PCT,
        I.FATOR_PRECO,

        P.PEDIDO_ID,
        P.TEMPO_SK,
        P.CLIENTE_SK,
        PR.PRODUTO_SK,
        P.VENDEDOR_SK,
        P.CANAL_SK,
        P.STATUS_VENDA_SK,

        PR.PRECO_LISTA,
        PR.CUSTO_PADRAO

    FROM ITENS_BASE I

    INNER JOIN PEDIDOS_DIMENSIONADOS P
        ON P.NUMERO_PEDIDO = I.NUMERO_PEDIDO

    INNER JOIN PRODUTOS_ENUMERADOS PR
        ON PR.NUMERO_PRODUTO =
            MOD(
                (I.NUMERO_ITEM_GERAL * 7) - 1,
                PR.TOTAL_PRODUTOS
            ) + 1
),

/* ============================================================
   13. Cálculo do preço unitário
   ============================================================ */
CALCULO_PRECO AS (
    SELECT
        I.*,

        ROUND(
            I.PRECO_LISTA * I.FATOR_PRECO,
            2
        ) AS PRECO_UNITARIO

    FROM ITENS_DIMENSIONADOS I
),

/* ============================================================
   14. Cálculo dos valores bruto e de custo
   ============================================================ */
CALCULO_VALOR_BRUTO AS (
    SELECT
        C.*,

        ROUND(
            C.QUANTIDADE * C.PRECO_UNITARIO,
            2
        ) AS VALOR_BRUTO,

        ROUND(
            C.QUANTIDADE * C.CUSTO_PADRAO,
            2
        ) AS CUSTO_TOTAL

    FROM CALCULO_PRECO C
),

/* ============================================================
   15. Cálculo do valor do desconto
   ============================================================ */
CALCULO_DESCONTO AS (
    SELECT
        C.*,

        ROUND(
            C.VALOR_BRUTO
            * C.DESCONTO_PCT
            / 100,
            2
        ) AS VALOR_DESCONTO

    FROM CALCULO_VALOR_BRUTO C
),

/* ============================================================
   16. Cálculo do valor líquido
   ============================================================ */
CALCULO_VALOR_LIQUIDO AS (
    SELECT
        C.*,

        ROUND(
            C.VALOR_BRUTO
            - C.VALOR_DESCONTO,
            2
        ) AS VALOR_LIQUIDO

    FROM CALCULO_DESCONTO C
),

/* ============================================================
   17. Cálculo do lucro
   ============================================================ */
RESULTADO_FINAL AS (
    SELECT
        PEDIDO_ID,
        ITEM_PEDIDO,
        TEMPO_SK,
        CLIENTE_SK,
        PRODUTO_SK,
        VENDEDOR_SK,
        CANAL_SK,
        STATUS_VENDA_SK,
        QUANTIDADE,
        PRECO_UNITARIO,
        DESCONTO_PCT,
        VALOR_BRUTO,
        VALOR_DESCONTO,
        VALOR_LIQUIDO,
        CUSTO_TOTAL,

        ROUND(
            VALOR_LIQUIDO - CUSTO_TOTAL,
            2
        ) AS LUCRO

    FROM CALCULO_VALOR_LIQUIDO
)

/* ============================================================
   18. Inserção final

   O NOT EXISTS impede duplicidade caso o script seja
   executado novamente.
   ============================================================ */
SELECT
    R.PEDIDO_ID,
    R.ITEM_PEDIDO,
    R.TEMPO_SK,
    R.CLIENTE_SK,
    R.PRODUTO_SK,
    R.VENDEDOR_SK,
    R.CANAL_SK,
    R.STATUS_VENDA_SK,
    R.QUANTIDADE,
    R.PRECO_UNITARIO,
    R.DESCONTO_PCT,
    R.VALOR_BRUTO,
    R.VALOR_DESCONTO,
    R.VALOR_LIQUIDO,
    R.CUSTO_TOTAL,
    R.LUCRO

FROM RESULTADO_FINAL R

WHERE NOT EXISTS (
    SELECT 1
    FROM FATO_VENDAS F
    WHERE F.PEDIDO_ID = R.PEDIDO_ID
      AND F.ITEM_PEDIDO = R.ITEM_PEDIDO
);

COMMIT;
