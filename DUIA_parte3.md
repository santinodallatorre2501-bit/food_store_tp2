DUIA - Parte 3

Herramienta: OpenCode (corriendo local).

Pedido: Análisis crítico de los scripts con fallas ocultas (UPDATE global sin filtro y subconsulta con NOT IN vulnerable a NULL).

Respuesta: Explicó qué efecto real generaban en la base y propuso las correcciones seguras con WHERE temporal y NOT EXISTS.

Cambios: Pasé el análisis y las refactorizaciones directo al archivo ejercicio_lectura_critica.md.

Las pruebas: Se hizo una revisión línea por línea del impacto de los comandos antes de commitearlos.

