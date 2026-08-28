Copia: Siempre se trabaja sobre una base de desarrollo usando createdb -T base_food_store copia_trabajo.
Transacción: Todo script generado se corre primero dentro de un bloque BEGIN; y se inspecciona antes de hacer COMMIT; o ROLLBACK;.
Respaldo: Antes de aplicar un cambio estructural, se genera un dump con pg_dump -d copia_trabajo > backup.sql.