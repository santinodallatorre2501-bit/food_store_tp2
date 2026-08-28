Análisis del Script 1



Lo que dice hacer: Dar de baja las funciones de películas retiradas de cartel.



Lo que hace realmente: Tal como está escrito (UPDATE funcion SET activa = FALSE;), no tiene cláusula WHERE, por lo que desactiva absolutamente todas las funciones de la base de datos de un solo golpe.



Por qué no coincide: Borra o desactiva las funciones de las películas que todavía siguen en cartelera.



Versión corregida: Hay que acotar el alcance con un filtro temporal o de estado:

UPDATE funcion

SET activa = FALSE

WHERE fecha\_funcion < CURRENT\_DATE;



Análisis del Script 2 (La trampa del NOT IN y los NULL)



Lo que dice hacer: Limpiar las categorías que no tienen productos asociados.



Lo que hace realmente: Usa un DELETE con NOT IN (SELECT categoria\_id FROM producto). En SQL, si la subconsulta devuelve aunque sea un solo valor NULL, la condición entera del NOT IN se rompe y no borra nada, o se comporta de forma impredecible.



Por qué no coincide: Puede fallar silenciosamente y dejar todas las categorías huerfanas sin borrar, o romper la lógica esperada.



Versión corregida: Conviene usar NOT EXISTS, que maneja los nulos de forma segura y eficiente:

DELETE FROM categoria c

WHERE NOT EXISTS (

&#x20;   SELECT 1 FROM producto p 

&#x20;   WHERE p.categoria\_id = c.id

);

