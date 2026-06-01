-- 1. Ver todos los clientes
SELECT * FROM clientes;

-- 2. Ver todos los comerciales
SELECT * FROM comercial;

-- 3. Ver toda la auditoría
SELECT * FROM auditoria;

-- 4. Ver solo nombres y ciudades de clientes
SELECT nombre_c, apellido1, ciudad FROM clientes;

-- 5. Ver comerciales y sus comisiones
SELECT nombre_co, apellido1, comision FROM comercial;
-- 6. Clientes de Tenerife
SELECT * FROM clientes WHERE ciudad = 'Tenerife';

-- 7. Comerciales con comisión mayor a 0.20
SELECT * FROM comercial WHERE comision > 0.20;

-- 8. Clientes que tienen email registrado
SELECT nombre_c, apellido1, email FROM clientes WHERE email IS NOT NULL;

-- 9. Clientes sin teléfono fijo ni móvil
SELECT nombre_c, apellido1 FROM clientes WHERE tlf_c IS NULL AND tlf_movil IS NULL;

-- 10. Auditorías del usuario root
SELECT * FROM auditoria WHERE usuario = 'root@localhost';
-- 11. Comerciales con sus registros de auditoría
SELECT c.nombre_co, c.apellido1, a.fecha_modificacion, a.comisionAnterior, a.comisionActual
FROM comercial c
JOIN auditoria a ON c.id_comercial = a.id_comercial;

-- 12. Comerciales SIN registro en auditoría
SELECT c.nombre_co, c.apellido1, c.comision
FROM comercial c
LEFT JOIN auditoria a ON c.id_comercial = a.id_comercial
WHERE a.id_comercial IS NULL;

-- 13. Auditoría mostrando nombre del comercial y cambio de comisión
SELECT c.nombre_co, c.apellido1, a.usuario, a.fecha_modificacion, 
       a.comisionAnterior, a.comisionActual
FROM auditoria a
JOIN comercial c ON a.id_comercial = c.id_comercial
ORDER BY a.fecha_modificacion;
-- 14. Comerciales con comisión por encima de la media
SELECT nombre_co, apellido1, comision
FROM comercial
WHERE comision > (SELECT AVG(comision) FROM comercial)
ORDER BY comision DESC;

-- 15. Cuántos clientes hay por ciudad ordenado de mayor a menor
SELECT ciudad, COUNT(*) AS total_clientes
FROM clientes
GROUP BY ciudad
ORDER BY total_clientes DESC;
