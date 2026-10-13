
-- ============================================================
-- PRE-ENTREGA M5 - RETAILPRO
-- Archivo: m5_consultas_joins.sql
-- Titulo: Cruzando tablas para enriquecer el analisis
-- Base de datos: 1-ventas_tech_db.sql
-- ============================================================

-- CONSULTA 1: VISTA BASE DEL PROYECTO
-- INNER JOIN: ventas, clientes, productos y categorias.
-- Objetivo: obtener una vista enriquecida para Power BI.

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email AS email_cliente,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- CONSULTA 2: CLIENTES SIN VENTAS
-- LEFT JOIN + IS NULL.
-- Objetivo: identificar clientes que nunca compraron.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;


-- CONSULTA 3: PRODUCTOS SIN VENTAS
-- LEFT JOIN + IS NULL.
-- Objetivo: identificar productos sin movimientos registrados.

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;

-- ============================================================
-- CONSULTA 4: CONSOLIDADO DE VENTAS POR PERIODO
-- UNION ALL + GROUP BY
-- Objetivo: comparar las ventas de 2025 y 2026.
-- La columna canal se crea como etiqueta del periodo.
-- ============================================================

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Ventas 2025' AS canal
    FROM ventas
    WHERE fecha_venta >= DATE '2025-01-01'
      AND fecha_venta < DATE '2026-01-01'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Ventas 2026' AS canal
    FROM ventas
    WHERE fecha_venta >= DATE '2026-01-01'
      AND fecha_venta < DATE '2027-01-01'
) AS consolidado
GROUP BY canal
ORDER BY canal;


