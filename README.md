# RetailChain — UNION y UNION ALL

**Autor:** Gastón Rivarola
**Motor:** SQL Server (SSMS)

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `schema.sql` | Crea las tablas de inventario de las sucursales Norte y Sur y carga los datos de prueba |
| `soluciones.sql` | Consultas con UNION, UNION ALL y la comparación de filas |
| `README.md` | Respuestas y justificaciones |

## Cómo ejecutarlo

1. Crear una base (por ejemplo `CREATE DATABASE retailchain;`) y seleccionarla.
2. Ejecutar `schema.sql`.
3. Ejecutar las consultas de `soluciones.sql` de a una.

Resultados esperados: Consulta 1 (UNION) = 11 filas, Consulta 2 (UNION ALL) = 14 filas.

---

## Respuestas

### 1. ¿Cuántas filas devuelve cada consulta y por qué son distintas?

- **UNION (Consulta 1): 11 filas.**
- **UNION ALL (Consulta 2): 14 filas.**

Cada sucursal tiene 7 registros, así que `UNION ALL` devuelve los 14 sin tocar nada. `UNION` elimina las filas completamente idénticas, y quedan 11. Las 3 filas que se eliminaron son los productos que existen en las dos sucursales con exactamente los mismos datos (id, nombre y categoría):

- 103 — Monitor 4K 27"
- 104 — Teclado Mecánico
- 106 — SSD Externo 1TB

La **Webcam HD 1080p** no se elimina porque en Norte tiene `id_producto = 107` y en Sur `111`: las filas no son idénticas, aunque el nombre sea el mismo.

En la Consulta 1 dejé afuera la columna `stock` a propósito. Los productos 103, 104 y 106 tienen un stock distinto en cada sucursal (por ejemplo, el 103 tiene 5 en Norte y 3 en Sur), entonces con `stock` incluido las filas no serían idénticas y `UNION` también devolvería 14 filas, sin eliminar nada.

### 2. ¿Por qué UNION ALL es más eficiente que UNION?

`UNION ALL` simplemente concatena los resultados de las dos consultas. `UNION`, además, tiene que **eliminar duplicados**: para eso el motor ordena o agrupa (hash) todas las filas del resultado y las compara entre sí. Esa operación adicional consume memoria y tiempo de CPU, y se nota más cuanto más grandes son las tablas. Por eso, si sé que no hay duplicados o los necesito, conviene `UNION ALL`.

### 3. ¿En qué casos de negocio usaría cada uno?

**UNION (necesito valores únicos):**
- Lista de clientes de dos campañas de marketing distintas, para enviar un mail sin mandarle dos veces al mismo cliente.
- Lista de choferes o proveedores que figuran en planillas de distintas sucursales, para tener un padrón único.

**UNION ALL (necesito todos los registros):**
- Consolidar las ventas de enero y febrero (cada mes en una tabla) para calcular el total facturado: si se eliminaran filas repetidas, el total quedaría subestimado.
- Juntar los movimientos de contenedores de dos terminales para contar todos los movimientos del período, incluidos los que se repiten.

### 4. ¿Qué pasa si las columnas de ambas consultas no coinciden en número o tipo?

- **Distinto número de columnas:** SQL Server devuelve un error: *"All queries combined using a UNION, INTERSECT or EXCEPT operator must have an equal number of expressions in their target lists."* (Msg 205).
- **Tipos incompatibles:** SQL Server intenta convertirlos implícitamente. Si no puede (por ejemplo, un texto como 'Laptop' contra un número entero), da un error de conversión, como *"Conversion failed when converting the varchar value ... to data type int."* (Msg 245).

Por eso ambas consultas deben tener la misma cantidad de columnas, en el mismo orden y con tipos compatibles.
