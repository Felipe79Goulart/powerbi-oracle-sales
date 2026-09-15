/* ============================================================
   CARGA CORRIGIDA: DIM_CANAL

   A coluna CANAL_SK é omitida para ser gerada automaticamente.
   ============================================================ */

INSERT INTO DIM_CANAL (
    CANAL_ID,
    CANAL_CODIGO,
    NOME_CANAL_PT_BR,
    NOME_CANAL_EN_US,
    TIPO_CANAL_CODIGO,
    TIPO_CANAL_PT_BR,
    TIPO_CANAL_EN_US,
    ATIVO
)
SELECT
    'CAN001',
    'PHYSICAL_STORE',
    'Loja Física',
    'Physical Store',
    'IN_PERSON',
    'Presencial',
    'In-person',
    'S'
FROM DUAL

UNION ALL

SELECT
    'CAN002',
    'ECOMMERCE',
    'E-commerce',
    'E-commerce',
    'DIGITAL',
    'Digital',
    'Digital',
    'S'
FROM DUAL

UNION ALL

SELECT
    'CAN003',
    'MARKETPLACE',
    'Marketplace',
    'Marketplace',
    'DIGITAL',
    'Digital',
    'Digital',
    'S'
FROM DUAL

UNION ALL

SELECT
    'CAN004',
    'TELESALES',
    'Televendas',
    'Telesales',
    'REMOTE',
    'Remoto',
    'Remote',
    'S'
FROM DUAL

UNION ALL

SELECT
    'CAN005',
    'SALES_REPRESENTATIVES',
    'Representantes',
    'Sales Representatives',
    'IN_PERSON',
    'Presencial',
    'In-person',
    'S'
FROM DUAL;

COMMIT;


/* ============================================================
   CARGA IDEMPOTENTE: DIM_PRODUTO

   REGRA:
   - Atualiza o produto caso PRODUTO_ID já exista.
   - Insere o produto caso ainda não exista.
   - PRODUTO_SK é gerada automaticamente pela IDENTITY.
   ============================================================ */

MERGE INTO DIM_PRODUTO DESTINO
USING (
    SELECT
        'PROD001' AS PRODUTO_ID,
        'Notebook Profissional' AS NOME_PRODUTO_PT_BR,
        'Business Laptop' AS NOME_PRODUTO_EN_US,
        'COMPUTERS' AS CATEGORIA_CODIGO,
        'Informática' AS CATEGORIA_PT_BR,
        'Computers' AS CATEGORIA_EN_US,
        'LAPTOPS' AS SUBCATEGORIA_CODIGO,
        'Notebooks' AS SUBCATEGORIA_PT_BR,
        'Laptops' AS SUBCATEGORIA_EN_US,
        'TechOne' AS MARCA,
        5899.90 AS PRECO_LISTA,
        4100.00 AS CUSTO_PADRAO,
        'S' AS ATIVO,
        DATE '2024-01-01' AS DATA_INICIO,
        DATE '9999-12-31' AS DATA_FIM,
        'S' AS REGISTRO_ATUAL
    FROM DUAL

    UNION ALL

    SELECT
        'PROD002',
        'Notebook Essencial',
        'Essential Laptop',
        'COMPUTERS',
        'Informática',
        'Computers',
        'LAPTOPS',
        'Notebooks',
        'Laptops',
        'TechOne',
        3299.90,
        2300.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD003',
        'Monitor LED 24 Polegadas',
        '24-inch LED Monitor',
        'COMPUTERS',
        'Informática',
        'Computers',
        'MONITORS',
        'Monitores',
        'Monitors',
        'Vision',
        1099.90,
        690.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD004',
        'Monitor Ultrawide 29 Polegadas',
        '29-inch Ultrawide Monitor',
        'COMPUTERS',
        'Informática',
        'Computers',
        'MONITORS',
        'Monitores',
        'Monitors',
        'Vision',
        1899.90,
        1250.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD005',
        'Mouse Sem Fio',
        'Wireless Mouse',
        'ACCESSORIES',
        'Acessórios',
        'Accessories',
        'MICE',
        'Mouses',
        'Mice',
        'Connect',
        149.90,
        65.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD006',
        'Teclado Mecânico',
        'Mechanical Keyboard',
        'ACCESSORIES',
        'Acessórios',
        'Accessories',
        'KEYBOARDS',
        'Teclados',
        'Keyboards',
        'Connect',
        399.90,
        210.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD007',
        'Headset Profissional',
        'Professional Headset',
        'ACCESSORIES',
        'Acessórios',
        'Accessories',
        'AUDIO',
        'Áudio',
        'Audio',
        'SoundMax',
        349.90,
        180.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD008',
        'Smartphone Plus 128GB',
        'Smartphone Plus 128GB',
        'MOBILE_DEVICES',
        'Telefonia',
        'Mobile Devices',
        'SMARTPHONES',
        'Smartphones',
        'Smartphones',
        'MobileX',
        2999.90,
        2050.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD009',
        'Smartphone Pro 256GB',
        'Smartphone Pro 256GB',
        'MOBILE_DEVICES',
        'Telefonia',
        'Mobile Devices',
        'SMARTPHONES',
        'Smartphones',
        'Smartphones',
        'MobileX',
        4599.90,
        3150.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD010',
        'Tablet Corporativo 10 Polegadas',
        '10-inch Business Tablet',
        'MOBILE_DEVICES',
        'Telefonia',
        'Mobile Devices',
        'TABLETS',
        'Tablets',
        'Tablets',
        'MobileX',
        2499.90,
        1700.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD011',
        'Impressora Laser',
        'Laser Printer',
        'OFFICE',
        'Escritório',
        'Office',
        'PRINTERS',
        'Impressoras',
        'Printers',
        'PrintMax',
        1799.90,
        1150.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD012',
        'Impressora Multifuncional',
        'Multifunction Printer',
        'OFFICE',
        'Escritório',
        'Office',
        'PRINTERS',
        'Impressoras',
        'Printers',
        'PrintMax',
        2299.90,
        1480.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD013',
        'Cadeira Ergonômica',
        'Ergonomic Chair',
        'FURNITURE',
        'Móveis',
        'Furniture',
        'CHAIRS',
        'Cadeiras',
        'Chairs',
        'OfficePro',
        1599.90,
        870.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD014',
        'Mesa Corporativa',
        'Corporate Desk',
        'FURNITURE',
        'Móveis',
        'Furniture',
        'DESKS',
        'Mesas',
        'Desks',
        'OfficePro',
        2199.90,
        1260.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'PROD015',
        'Webcam Full HD',
        'Full HD Webcam',
        'ACCESSORIES',
        'Acessórios',
        'Accessories',
        'VIDEO',
        'Vídeo',
        'Video',
        'Vision',
        299.90,
        145.00,
        'S',
        DATE '2024-01-01',
        DATE '9999-12-31',
        'S'
    FROM DUAL
) ORIGEM
ON (
    DESTINO.PRODUTO_ID = ORIGEM.PRODUTO_ID
)

WHEN MATCHED THEN
    UPDATE SET
        DESTINO.NOME_PRODUTO_PT_BR =
            ORIGEM.NOME_PRODUTO_PT_BR,

        DESTINO.NOME_PRODUTO_EN_US =
            ORIGEM.NOME_PRODUTO_EN_US,

        DESTINO.CATEGORIA_CODIGO =
            ORIGEM.CATEGORIA_CODIGO,

        DESTINO.CATEGORIA_PT_BR =
            ORIGEM.CATEGORIA_PT_BR,

        DESTINO.CATEGORIA_EN_US =
            ORIGEM.CATEGORIA_EN_US,

        DESTINO.SUBCATEGORIA_CODIGO =
            ORIGEM.SUBCATEGORIA_CODIGO,

        DESTINO.SUBCATEGORIA_PT_BR =
            ORIGEM.SUBCATEGORIA_PT_BR,

        DESTINO.SUBCATEGORIA_EN_US =
            ORIGEM.SUBCATEGORIA_EN_US,

        DESTINO.MARCA =
            ORIGEM.MARCA,

        DESTINO.PRECO_LISTA =
            ORIGEM.PRECO_LISTA,

        DESTINO.CUSTO_PADRAO =
            ORIGEM.CUSTO_PADRAO,

        DESTINO.ATIVO =
            ORIGEM.ATIVO,

        DESTINO.DATA_INICIO =
            ORIGEM.DATA_INICIO,

        DESTINO.DATA_FIM =
            ORIGEM.DATA_FIM,

        DESTINO.REGISTRO_ATUAL =
            ORIGEM.REGISTRO_ATUAL

WHEN NOT MATCHED THEN
    INSERT (
        PRODUTO_ID,
        NOME_PRODUTO_PT_BR,
        NOME_PRODUTO_EN_US,
        CATEGORIA_CODIGO,
        CATEGORIA_PT_BR,
        CATEGORIA_EN_US,
        SUBCATEGORIA_CODIGO,
        SUBCATEGORIA_PT_BR,
        SUBCATEGORIA_EN_US,
        MARCA,
        PRECO_LISTA,
        CUSTO_PADRAO,
        ATIVO,
        DATA_INICIO,
        DATA_FIM,
        REGISTRO_ATUAL
    )
    VALUES (
        ORIGEM.PRODUTO_ID,
        ORIGEM.NOME_PRODUTO_PT_BR,
        ORIGEM.NOME_PRODUTO_EN_US,
        ORIGEM.CATEGORIA_CODIGO,
        ORIGEM.CATEGORIA_PT_BR,
        ORIGEM.CATEGORIA_EN_US,
        ORIGEM.SUBCATEGORIA_CODIGO,
        ORIGEM.SUBCATEGORIA_PT_BR,
        ORIGEM.SUBCATEGORIA_EN_US,
        ORIGEM.MARCA,
        ORIGEM.PRECO_LISTA,
        ORIGEM.CUSTO_PADRAO,
        ORIGEM.ATIVO,
        ORIGEM.DATA_INICIO,
        ORIGEM.DATA_FIM,
        ORIGEM.REGISTRO_ATUAL
    );

COMMIT;


/* ============================================================
   CARGA IDEMPOTENTE: DIM_VENDEDOR

   REGRA:
   - Atualiza pelo VENDEDOR_ID quando o registro já existe;
   - Insere quando ainda não existe;
   - VENDEDOR_SK é gerada automaticamente.
   ============================================================ */

MERGE INTO DIM_VENDEDOR DESTINO
USING (
    SELECT
        'VEN001' AS VENDEDOR_ID,
        'Ana Souza' AS NOME_VENDEDOR,
        'SOUTHEAST_TEAM' AS EQUIPE_CODIGO,
        'Equipe Sudeste' AS EQUIPE_PT_BR,
        'Southeast Team' AS EQUIPE_EN_US,
        'Marcos Lima' AS GERENTE,
        'São Paulo' AS CIDADE,
        'SP' AS ESTADO,
        'SOUTHEAST' AS REGIAO_CODIGO,
        'Sudeste' AS REGIAO_PT_BR,
        'Southeast' AS REGIAO_EN_US,
        DATE '2021-03-15' AS DATA_ADMISSAO,
        350000 AS META_MENSAL,
        'S' AS ATIVO
    FROM DUAL

    UNION ALL

    SELECT
        'VEN002',
        'Bruno Martins',
        'SOUTHEAST_TEAM',
        'Equipe Sudeste',
        'Southeast Team',
        'Marcos Lima',
        'Rio de Janeiro',
        'RJ',
        'SOUTHEAST',
        'Sudeste',
        'Southeast',
        DATE '2022-01-10',
        320000,
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'VEN003',
        'Carla Oliveira',
        'SOUTH_TEAM',
        'Equipe Sul',
        'South Team',
        'Fernanda Alves',
        'Curitiba',
        'PR',
        'SOUTH',
        'Sul',
        'South',
        DATE '2020-08-20',
        280000,
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'VEN004',
        'Daniel Santos',
        'SOUTH_TEAM',
        'Equipe Sul',
        'South Team',
        'Fernanda Alves',
        'Porto Alegre',
        'RS',
        'SOUTH',
        'Sul',
        'South',
        DATE '2023-02-06',
        260000,
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'VEN005',
        'Eduarda Lima',
        'NORTHEAST_TEAM',
        'Equipe Nordeste',
        'Northeast Team',
        'Ricardo Costa',
        'Salvador',
        'BA',
        'NORTHEAST',
        'Nordeste',
        'Northeast',
        DATE '2021-11-01',
        240000,
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'VEN006',
        'Felipe Rocha',
        'NORTHEAST_TEAM',
        'Equipe Nordeste',
        'Northeast Team',
        'Ricardo Costa',
        'Recife',
        'PE',
        'NORTHEAST',
        'Nordeste',
        'Northeast',
        DATE '2022-07-18',
        230000,
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'VEN007',
        'Gabriela Mendes',
        'MIDWEST_TEAM',
        'Equipe Centro-Oeste',
        'Midwest Team',
        'Patrícia Reis',
        'Brasília',
        'DF',
        'MIDWEST',
        'Centro-Oeste',
        'Midwest',
        DATE '2020-05-12',
        270000,
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'VEN008',
        'Henrique Costa',
        'NORTH_TEAM',
        'Equipe Norte',
        'North Team',
        'Patrícia Reis',
        'Manaus',
        'AM',
        'NORTH',
        'Norte',
        'North',
        DATE '2023-09-04',
        200000,
        'S'
    FROM DUAL
) ORIGEM
ON (
    DESTINO.VENDEDOR_ID = ORIGEM.VENDEDOR_ID
)

WHEN MATCHED THEN
    UPDATE SET
        DESTINO.NOME_VENDEDOR = ORIGEM.NOME_VENDEDOR,
        DESTINO.EQUIPE_CODIGO = ORIGEM.EQUIPE_CODIGO,
        DESTINO.EQUIPE_PT_BR = ORIGEM.EQUIPE_PT_BR,
        DESTINO.EQUIPE_EN_US = ORIGEM.EQUIPE_EN_US,
        DESTINO.GERENTE = ORIGEM.GERENTE,
        DESTINO.CIDADE = ORIGEM.CIDADE,
        DESTINO.ESTADO = ORIGEM.ESTADO,
        DESTINO.REGIAO_CODIGO = ORIGEM.REGIAO_CODIGO,
        DESTINO.REGIAO_PT_BR = ORIGEM.REGIAO_PT_BR,
        DESTINO.REGIAO_EN_US = ORIGEM.REGIAO_EN_US,
        DESTINO.DATA_ADMISSAO = ORIGEM.DATA_ADMISSAO,
        DESTINO.META_MENSAL = ORIGEM.META_MENSAL,
        DESTINO.ATIVO = ORIGEM.ATIVO

WHEN NOT MATCHED THEN
    INSERT (
        VENDEDOR_ID,
        NOME_VENDEDOR,
        EQUIPE_CODIGO,
        EQUIPE_PT_BR,
        EQUIPE_EN_US,
        GERENTE,
        CIDADE,
        ESTADO,
        REGIAO_CODIGO,
        REGIAO_PT_BR,
        REGIAO_EN_US,
        DATA_ADMISSAO,
        META_MENSAL,
        ATIVO
    )
    VALUES (
        ORIGEM.VENDEDOR_ID,
        ORIGEM.NOME_VENDEDOR,
        ORIGEM.EQUIPE_CODIGO,
        ORIGEM.EQUIPE_PT_BR,
        ORIGEM.EQUIPE_EN_US,
        ORIGEM.GERENTE,
        ORIGEM.CIDADE,
        ORIGEM.ESTADO,
        ORIGEM.REGIAO_CODIGO,
        ORIGEM.REGIAO_PT_BR,
        ORIGEM.REGIAO_EN_US,
        ORIGEM.DATA_ADMISSAO,
        ORIGEM.META_MENSAL,
        ORIGEM.ATIVO
    );

COMMIT;


/* ============================================================
   CARGA IDEMPOTENTE: DIM_CLIENTE

   REGRA:
   - Atualiza pelo CLIENTE_ID quando já existir;
   - Insere quando ainda não existir;
   - CLIENTE_SK é gerada automaticamente pela IDENTITY.
   ============================================================ */

MERGE INTO DIM_CLIENTE DESTINO
USING (
    SELECT
        'CLI001' AS CLIENTE_ID,
        'Alfa Tecnologia Ltda' AS NOME_CLIENTE,
        'PJ' AS TIPO_PESSOA,
        'CORPORATE' AS SEGMENTO_CODIGO,
        'Corporativo' AS SEGMENTO_PT_BR,
        'Corporate' AS SEGMENTO_EN_US,
        'contato@alfa.com' AS EMAIL,
        'São Paulo' AS CIDADE,
        'SP' AS ESTADO,
        'SOUTHEAST' AS REGIAO_CODIGO,
        'Sudeste' AS REGIAO_PT_BR,
        'Southeast' AS REGIAO_EN_US,
        'BRA' AS PAIS_CODIGO,
        'Brasil' AS PAIS_PT_BR,
        'Brazil' AS PAIS_EN_US,
        DATE '2023-02-10' AS DATA_CADASTRO,
        'S' AS ATIVO,
        DATE '2023-02-10' AS DATA_INICIO,
        DATE '9999-12-31' AS DATA_FIM,
        'S' AS REGISTRO_ATUAL
    FROM DUAL

    UNION ALL

    SELECT
        'CLI002',
        'Beta Comércio S.A.',
        'PJ',
        'CORPORATE',
        'Corporativo',
        'Corporate',
        'compras@beta.com',
        'Rio de Janeiro',
        'RJ',
        'SOUTHEAST',
        'Sudeste',
        'Southeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-03-15',
        'S',
        DATE '2023-03-15',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI003',
        'Carlos Almeida',
        'PF',
        'CONSUMER',
        'Consumidor',
        'Consumer',
        'carlos@email.com',
        'Belo Horizonte',
        'MG',
        'SOUTHEAST',
        'Sudeste',
        'Southeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-04-20',
        'S',
        DATE '2023-04-20',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI004',
        'Delta Serviços Ltda',
        'PJ',
        'SMALL_BUSINESS',
        'Pequenas Empresas',
        'Small Business',
        'financeiro@delta.com',
        'Campinas',
        'SP',
        'SOUTHEAST',
        'Sudeste',
        'Southeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-05-08',
        'S',
        DATE '2023-05-08',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI005',
        'Empresa Horizonte',
        'PJ',
        'CORPORATE',
        'Corporativo',
        'Corporate',
        'compras@horizonte.com',
        'Curitiba',
        'PR',
        'SOUTH',
        'Sul',
        'South',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-06-12',
        'S',
        DATE '2023-06-12',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI006',
        'Fernanda Ribeiro',
        'PF',
        'CONSUMER',
        'Consumidor',
        'Consumer',
        'fernanda@email.com',
        'Porto Alegre',
        'RS',
        'SOUTH',
        'Sul',
        'South',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-07-25',
        'S',
        DATE '2023-07-25',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI007',
        'Gamma Distribuidora',
        'PJ',
        'DISTRIBUTOR',
        'Distribuidor',
        'Distributor',
        'comercial@gamma.com',
        'Florianópolis',
        'SC',
        'SOUTH',
        'Sul',
        'South',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-08-14',
        'S',
        DATE '2023-08-14',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI008',
        'Grupo Nordeste S.A.',
        'PJ',
        'CORPORATE',
        'Corporativo',
        'Corporate',
        'compras@gruponordeste.com',
        'Salvador',
        'BA',
        'NORTHEAST',
        'Nordeste',
        'Northeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-09-18',
        'S',
        DATE '2023-09-18',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI009',
        'Igor Barbosa',
        'PF',
        'CONSUMER',
        'Consumidor',
        'Consumer',
        'igor@email.com',
        'Recife',
        'PE',
        'NORTHEAST',
        'Nordeste',
        'Northeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-10-04',
        'S',
        DATE '2023-10-04',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI010',
        'JLM Consultoria',
        'PJ',
        'SMALL_BUSINESS',
        'Pequenas Empresas',
        'Small Business',
        'contato@jlm.com',
        'Fortaleza',
        'CE',
        'NORTHEAST',
        'Nordeste',
        'Northeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2023-11-16',
        'S',
        DATE '2023-11-16',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI011',
        'Kappa Indústria',
        'PJ',
        'CORPORATE',
        'Corporativo',
        'Corporate',
        'suprimentos@kappa.com',
        'Brasília',
        'DF',
        'MIDWEST',
        'Centro-Oeste',
        'Midwest',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-01-11',
        'S',
        DATE '2024-01-11',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI012',
        'Larissa Moreira',
        'PF',
        'CONSUMER',
        'Consumidor',
        'Consumer',
        'larissa@email.com',
        'Goiânia',
        'GO',
        'MIDWEST',
        'Centro-Oeste',
        'Midwest',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-02-22',
        'S',
        DATE '2024-02-22',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI013',
        'Matriz Engenharia',
        'PJ',
        'CORPORATE',
        'Corporativo',
        'Corporate',
        'compras@matriz.com',
        'Cuiabá',
        'MT',
        'MIDWEST',
        'Centro-Oeste',
        'Midwest',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-03-19',
        'S',
        DATE '2024-03-19',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI014',
        'Norte Digital Ltda',
        'PJ',
        'SMALL_BUSINESS',
        'Pequenas Empresas',
        'Small Business',
        'contato@nortedigital.com',
        'Manaus',
        'AM',
        'NORTH',
        'Norte',
        'North',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-04-09',
        'S',
        DATE '2024-04-09',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI015',
        'Otávio Ferreira',
        'PF',
        'CONSUMER',
        'Consumidor',
        'Consumer',
        'otavio@email.com',
        'Belém',
        'PA',
        'NORTH',
        'Norte',
        'North',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-05-13',
        'S',
        DATE '2024-05-13',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI016',
        'Prime Soluções S.A.',
        'PJ',
        'CORPORATE',
        'Corporativo',
        'Corporate',
        'compras@prime.com',
        'São Paulo',
        'SP',
        'SOUTHEAST',
        'Sudeste',
        'Southeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-06-17',
        'S',
        DATE '2024-06-17',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI017',
        'Quality Office Ltda',
        'PJ',
        'DISTRIBUTOR',
        'Distribuidor',
        'Distributor',
        'vendas@quality.com',
        'Joinville',
        'SC',
        'SOUTH',
        'Sul',
        'South',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-07-08',
        'S',
        DATE '2024-07-08',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI018',
        'Renata Costa',
        'PF',
        'CONSUMER',
        'Consumidor',
        'Consumer',
        'renata@email.com',
        'Natal',
        'RN',
        'NORTHEAST',
        'Nordeste',
        'Northeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-08-21',
        'S',
        DATE '2024-08-21',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI019',
        'Sigma Tecnologia',
        'PJ',
        'CORPORATE',
        'Corporativo',
        'Corporate',
        'compras@sigma.com',
        'Vitória',
        'ES',
        'SOUTHEAST',
        'Sudeste',
        'Southeast',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-09-12',
        'S',
        DATE '2024-09-12',
        DATE '9999-12-31',
        'S'
    FROM DUAL

    UNION ALL

    SELECT
        'CLI020',
        'Top Business Ltda',
        'PJ',
        'SMALL_BUSINESS',
        'Pequenas Empresas',
        'Small Business',
        'contato@topbusiness.com',
        'Campo Grande',
        'MS',
        'MIDWEST',
        'Centro-Oeste',
        'Midwest',
        'BRA',
        'Brasil',
        'Brazil',
        DATE '2024-10-15',
        'S',
        DATE '2024-10-15',
        DATE '9999-12-31',
        'S'
    FROM DUAL
) ORIGEM
ON (
    DESTINO.CLIENTE_ID = ORIGEM.CLIENTE_ID
)

WHEN MATCHED THEN
    UPDATE SET
        DESTINO.NOME_CLIENTE       = ORIGEM.NOME_CLIENTE,
        DESTINO.TIPO_PESSOA        = ORIGEM.TIPO_PESSOA,
        DESTINO.SEGMENTO_CODIGO    = ORIGEM.SEGMENTO_CODIGO,
        DESTINO.SEGMENTO_PT_BR     = ORIGEM.SEGMENTO_PT_BR,
        DESTINO.SEGMENTO_EN_US     = ORIGEM.SEGMENTO_EN_US,
        DESTINO.EMAIL              = ORIGEM.EMAIL,
        DESTINO.CIDADE             = ORIGEM.CIDADE,
        DESTINO.ESTADO             = ORIGEM.ESTADO,
        DESTINO.REGIAO_CODIGO      = ORIGEM.REGIAO_CODIGO,
        DESTINO.REGIAO_PT_BR       = ORIGEM.REGIAO_PT_BR,
        DESTINO.REGIAO_EN_US       = ORIGEM.REGIAO_EN_US,
        DESTINO.PAIS_CODIGO        = ORIGEM.PAIS_CODIGO,
        DESTINO.PAIS_PT_BR         = ORIGEM.PAIS_PT_BR,
        DESTINO.PAIS_EN_US         = ORIGEM.PAIS_EN_US,
        DESTINO.DATA_CADASTRO      = ORIGEM.DATA_CADASTRO,
        DESTINO.ATIVO              = ORIGEM.ATIVO,
        DESTINO.DATA_INICIO        = ORIGEM.DATA_INICIO,
        DESTINO.DATA_FIM           = ORIGEM.DATA_FIM,
        DESTINO.REGISTRO_ATUAL     = ORIGEM.REGISTRO_ATUAL

WHEN NOT MATCHED THEN
    INSERT (
        CLIENTE_ID,
        NOME_CLIENTE,
        TIPO_PESSOA,
        SEGMENTO_CODIGO,
        SEGMENTO_PT_BR,
        SEGMENTO_EN_US,
        EMAIL,
        CIDADE,
        ESTADO,
        REGIAO_CODIGO,
        REGIAO_PT_BR,
        REGIAO_EN_US,
        PAIS_CODIGO,
        PAIS_PT_BR,
        PAIS_EN_US,
        DATA_CADASTRO,
        ATIVO,
        DATA_INICIO,
        DATA_FIM,
        REGISTRO_ATUAL
    )
    VALUES (
        ORIGEM.CLIENTE_ID,
        ORIGEM.NOME_CLIENTE,
        ORIGEM.TIPO_PESSOA,
        ORIGEM.SEGMENTO_CODIGO,
        ORIGEM.SEGMENTO_PT_BR,
        ORIGEM.SEGMENTO_EN_US,
        ORIGEM.EMAIL,
        ORIGEM.CIDADE,
        ORIGEM.ESTADO,
        ORIGEM.REGIAO_CODIGO,
        ORIGEM.REGIAO_PT_BR,
        ORIGEM.REGIAO_EN_US,
        ORIGEM.PAIS_CODIGO,
        ORIGEM.PAIS_PT_BR,
        ORIGEM.PAIS_EN_US,
        ORIGEM.DATA_CADASTRO,
        ORIGEM.ATIVO,
        ORIGEM.DATA_INICIO,
        ORIGEM.DATA_FIM,
        ORIGEM.REGISTRO_ATUAL
    );

COMMIT;


/* ============================================================
   CARGA: DIM_STATUS_VENDA
   ============================================================ */

INSERT ALL
    INTO DIM_STATUS_VENDA (
        STATUS_VENDA_SK,
        STATUS_VENDA_CODIGO,
        STATUS_VENDA_PT_BR,
        STATUS_VENDA_EN_US,
        ATIVO
    )
    VALUES (
        1,
        'INVOICED',
        'Faturado',
        'Invoiced',
        'S'
    )

    INTO DIM_STATUS_VENDA (
        STATUS_VENDA_SK,
        STATUS_VENDA_CODIGO,
        STATUS_VENDA_PT_BR,
        STATUS_VENDA_EN_US,
        ATIVO
    )
    VALUES (
        2,
        'DELIVERED',
        'Entregue',
        'Delivered',
        'S'
    )

    INTO DIM_STATUS_VENDA (
        STATUS_VENDA_SK,
        STATUS_VENDA_CODIGO,
        STATUS_VENDA_PT_BR,
        STATUS_VENDA_EN_US,
        ATIVO
    )
    VALUES (
        3,
        'RETURNED',
        'Devolvido',
        'Returned',
        'S'
    )

    INTO DIM_STATUS_VENDA (
        STATUS_VENDA_SK,
        STATUS_VENDA_CODIGO,
        STATUS_VENDA_PT_BR,
        STATUS_VENDA_EN_US,
        ATIVO
    )
    VALUES (
        4,
        'CANCELLED',
        'Cancelado',
        'Cancelled',
        'S'
    )
SELECT 1
FROM DUAL;

COMMIT;
