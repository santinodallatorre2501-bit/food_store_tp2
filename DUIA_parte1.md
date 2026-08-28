\# DUIA - Parte 1



\- Herramienta: OpenCode (corriendo local).

\- Pedido: Que agregue validaciones para que no se puedan cargar precios ni stock negativos, y que las cantidades de los pedidos sean mayores a cero.

\- Respuesta: Metió las restricciones con `CHECK` directo en el `schema.sql` en las tablas de productos y detalle de pedidos.

\- Cambios: Le acepté los `CHECK` tal cual porque estaban bien, pero tuve que sacar la línea del `USE food\_store\_db;` porque en SQLite me tiraba error de sintaxis.

\- Las pruebas: Hice un par de consultas de prueba metiendo datos inválidos en DBeaver y la base los rechazó.

