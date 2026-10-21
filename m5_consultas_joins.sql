
-- ============================================================
-- PRE-ENTREGA M5 - RETAILPRO
-- Archivo: m5_consultas_joins.sql
-- Titulo: Cruzando tablas para enriquecer el analisis
-- Base de datos: ventas_tech_db
-- ============================================================


-- ============================================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO
-- INNER JOIN: ventas, clientes, productos y categorias.
-- Objetivo: obtener una vista enriquecida para Power BI.
-- ============================================================

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

-- Hallazgo: Se obtuvieron 10 registros de ventas,
-- con informacion relacionada de clientes, productos
-- y categorias.
-- Para el negocio, esta vista permite analizar la
-- facturacion y preparar los datos para Power BI.


-- ============================================================
-- CONSULTA 2: CLIENTES SIN VENTAS
-- LEFT JOIN + IS NULL.
-- Objetivo: identificar clientes que nunca compraron.
-- ============================================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;

-- Hallazgo: Se identifico 1 cliente sin ventas registradas.
-- Desde CRM, este resultado permite detectar clientes
-- sin compras y evaluar acciones de seguimiento o
-- activacion comercial.


-- ============================================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS
-- LEFT JOIN + IS NULL.
-- Objetivo: identificar productos sin movimientos registrados.
-- ============================================================

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

-- Hallazgo: Se identifico 1 producto sin ventas registradas.
-- Para el area de producto, este resultado permite revisar
-- la visibilidad del articulo, las promociones y la
-- planificacion del stock.


-- ============================================================
-- CONSULTA 4: CONSOLIDADO DE VENTAS POR CANAL
-- Objetivo: practicar la consolidacion por canal usando
-- UNION ALL y GROUP BY.
-- IMPORTANTE: los canales son simulados para el ejercicio.
-- No representan canales reales registrados en las ventas.
-- ============================================================

SELECT
    canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_ventas
FROM (
    SELECT
        'Online' AS canal,
        cantidad * precio_unitario AS total
    FROM ventas
    WHERE id_venta % 2 = 0

    UNION ALL

    SELECT
        'Presencial' AS canal,
        cantidad * precio_unitario AS total
    FROM ventas
    WHERE id_venta % 2 <> 0
) AS ventas_por_canal
GROUP BY canal
ORDER BY canal;

-- Hallazgo: Se obtuvieron 2 filas de resumen, una por
-- cada canal simulado, con la cantidad de ventas y el
-- importe total correspondiente.
-- Esta estructura permite practicar la comparacion comercial
-- por canal. Para un analisis real, se necesita disponer
-- del canal efectivo de cada venta.


-- ============================================================
-- CONSULTA 5: RESUMEN GENERAL DE VENTAS
-- Objetivo: conocer las operaciones, unidades y facturacion.
-- ============================================================

SELECT
    COUNT(*) AS cantidad_ventas,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS facturacion_total,
    MIN(fecha_venta) AS primera_venta,
    MAX(fecha_venta) AS ultima_venta
FROM ventas;

-- Hallazgo: El resultado presenta 1 fila con 5 indicadores
-- generales, incluida la cantidad de ventas, las unidades,
-- la facturacion y las fechas extremas del periodo.
-- Para la gerencia, estos indicadores permiten dimensionar
-- el volumen comercial y la facturacion del negocio.

