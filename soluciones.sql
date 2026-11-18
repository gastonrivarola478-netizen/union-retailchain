-- ══════════════════════════════════════════
-- RetailChain — UNION y UNION ALL
-- Autor: GASTON RIVAROLA
-- Fecha: 18/11/2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: UNION ────────────────────
-- Reporte de Catálogo Unificado
-- Pregunta de negocio: ¿Qué productos únicos comercializa
-- la empresa en toda su red de sucursales?
-- Operador: UNION (elimina filas completamente duplicadas)
-- Decisión: no incluyo la columna stock, porque es distinta en cada sucursal
-- y haría que las filas no sean idénticas (UNION no eliminaría nada).
-- Resultado esperado: 11 filas.

SELECT id_producto, nombre_producto, categoria
FROM inventario_sucursal_norte
UNION
SELECT id_producto, nombre_producto, categoria
FROM inventario_sucursal_sur
ORDER BY id_producto;

-- ── CONSULTA 2: UNION ALL ────────────────
-- Auditoría de Stock Total
-- Pregunta de negocio: ¿Cuántos registros físicos de stock
-- existen en total entre ambas sucursales?
-- Operador: UNION ALL (mantiene todos los registros incluyendo duplicados)
-- Resultado esperado: 14 filas.

SELECT id_producto, nombre_producto, categoria, stock
FROM inventario_sucursal_norte
UNION ALL
SELECT id_producto, nombre_producto, categoria, stock
FROM inventario_sucursal_sur
ORDER BY id_producto;

-- ── CONSULTA 3: COMPARACIÓN DE RESULTADOS ─
-- Cuenta las filas que devuelve cada operador.
-- UNION devuelve 11 filas y UNION ALL devuelve 14 filas.

SELECT COUNT(*) AS filas_union
FROM (
    SELECT id_producto, nombre_producto, categoria
    FROM inventario_sucursal_norte
    UNION
    SELECT id_producto, nombre_producto, categoria
    FROM inventario_sucursal_sur
) AS resultado_union;

SELECT COUNT(*) AS filas_union_all
FROM (
    SELECT id_producto, nombre_producto, categoria
    FROM inventario_sucursal_norte
    UNION ALL
    SELECT id_producto, nombre_producto, categoria
    FROM inventario_sucursal_sur
) AS resultado_union_all;
