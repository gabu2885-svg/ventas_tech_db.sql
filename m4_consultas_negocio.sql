-- Consulta 1: Resumen ejecutivo mensual

SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-- Consulta 2: Top 5 de productos por facturación
SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- Consulta 3: Clientes con más de un pedido
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- Consulta 4: Meses comparados con el promedio
WITH ventas_mensuales AS (
    SELECT 
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado >= (SELECT AVG(total_facturado) FROM ventas_mensuales) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_mes
FROM ventas_mensuales
ORDER BY mes;

/*
HALLAZGOS DE NEGOCIO:
1. El producto ID 1-Laptop Pro 15 concentra la mayor parte de la facturación.
2. Maria Lopez es el cliente que mas compró
3. El mes 3 fue el de mayor facturación superando ampliamente el promedio.
*/