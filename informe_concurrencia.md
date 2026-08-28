Escenario 1: Espera por bloqueo



Escenario: Espera por bloqueo (Lock Wait).



Cómo se reprodujo: Sesión A ejecuta BEGIN TRANSACTION; UPDATE producto SET stock = 15 WHERE id\_producto = 1; (sin commit). Sesión B ejecuta UPDATE producto SET stock = 5 WHERE id\_producto = 1;.



Qué se observó: La Sesión B queda congelada (en espera activa) sin arrojar error de inmediato, hasta que la Sesión A libera el recurso con COMMIT;.



Explicación de la IA: Ocurre debido al mecanismo de control de concurrencia para operaciones de escritura. El motor aplica un bloqueo exclusivo sobre la fila modificada para evitar condiciones de carrera, obligando a las transacciones posteriores a esperar.



Verificación en el motor: Al repetir la prueba, se comprobó que la segunda sesión suspende su ejecución hasta recibir el commit de la primera, validando el bloqueo de registros.



Conclusión: La explicación se confirma; el motor bloquea las modificaciones simultáneas sobre un mismo registro para garantizar la consistencia de los datos.



Escenario 2: Lectura no repetible



Escenario: Lectura no repetible (Non-repeatable read).



Cómo se reprodujo: Sesión A consulta SELECT stock FROM producto WHERE id\_producto = 1; obteniendo un valor de 10. Sesión B modifica ese stock a 20 y hace COMMIT;. Sesión A vuelve a consultar el mismo producto dentro de su transacción activa.



Qué se observó: Bajo el nivel de aislamiento por defecto (Read Committed), la segunda consulta de la Sesión A devuelve 20, arrojando un resultado diferente al inicial.



Explicación de la IA: Sucede porque las operaciones de lectura no retienen bloqueos compartidos sobre las filas una vez leídas. Para evitar que los datos cambien a mitad de camino, se requiere el nivel Repeatable Read.



Verificación en el motor: Al configurar SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;, la segunda lectura de la Sesión A mantuvo el valor original de 10, ignorando la modificación externa hasta finalizar la transacción.



Conclusión: Se confirma la anomalía en el nivel estándar y su efectiva solución al subir el aislamiento a Repeatable Read.



Escenario 3: Lectura fantasma



Escenario: Lectura fantasma (Phantom read).



Cómo se reprodujo: Sesión A ejecuta un conteo con condición: SELECT COUNT(\*) FROM producto WHERE precio > 10000; (devuelve 3). Sesión B inserta un nuevo producto que cumple esa condición y hace COMMIT;. Sesión A repite la misma consulta.



Qué se observó: El resultado del conteo en la Sesión A pasa a ser 4, apareciendo un registro nuevo ("fantasma") que no estaba presente en la lectura inicial.



Explicación de la IA: Ocurre porque las condiciones por rango de valores no bloquean los conjuntos de inserción posibles. El nivel Serializable previene este comportamiento aislando completamente las operaciones mediante bloqueos de rango.



Verificación en el motor: Al elevar el aislamiento a Serializable, las consultas por rango impiden la inserción de nuevos registros coincidentes hasta que concluye la transacción principal.



Conclusión: La teoría es correcta; el nivel Serializable evita la aparición de fantasmas asegurando que el conjunto de datos consultado permanezca invariable.

