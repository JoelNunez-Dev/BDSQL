# Informe de Base de Datos — BDventas

## 1. Descripción general
La base de datos `ventas` está diseñada para gestionar información comercial
de una empresa. Contiene datos de clientes, comerciales y un sistema de 
auditoría que registra los cambios en las comisiones de los comerciales.

## 2. Estructura

### Tablas
- **clientes**: almacena datos personales y de contacto de los clientes
- **comercial**: almacena datos de los comerciales y sus comisiones
- **auditoria**: registra historial de cambios en las comisiones

### Relaciones
- `auditoria.id_comercial` referencia a `comercial.id_comercial`
- La tabla `clientes` no tiene relación definida con ninguna otra tabla
- No existen claves foráneas (FOREIGN KEY) declaradas formalmente

## 3. Análisis

### Qué está bien diseñado
- Las tablas tienen claves primarias (PRIMARY KEY) correctamente definidas
- El campo `email` en clientes tiene restricción UNIQUE, evitando duplicados
- La tabla `auditoria` guarda tanto la comisión anterior como la actual,
  lo que permite trazabilidad de los cambios
- Se usa AUTO_INCREMENT en los campos ID

### Qué no está claro
- El campo `importe` en la tabla `comercial` no tiene un propósito claro,
  aparece en casi todos los registros como NULL o con valores negativos
- Los campos `nombre_co` en comercial y `nombre_c` en clientes usan 
  nomenclaturas inconsistentes
- No queda claro si `comision` representa un porcentaje o un importe fijo,
  ya que hay valores como 0.30 y también 5.40

## 4. Problemas detectados

- **Falta tabla de pedidos/ventas**: siendo una BD llamada "ventas", no existe
  ninguna tabla que registre las ventas o pedidos realizados
- **Clientes sin relación**: la tabla `clientes` está completamente aislada,
  no se relaciona con ninguna otra tabla
- **Sin FOREIGN KEY formales**: la relación entre `auditoria` y `comercial`
  existe en los datos pero no está declarada como FK, lo que no garantiza
  integridad referencial
- **Datos inconsistentes en comercial**: existen registros duplicados 
  (filas 9 y 10 tienen los mismos datos) y valores negativos en `importe`
- **Teléfonos como INT**: los teléfonos se almacenan como enteros, lo que
  puede causar problemas con números que empiecen por 0

## 5. Propuestas de mejora

### Nueva tabla: pedidos
```sql
CREATE TABLE pedidos (
  id_pedido INT PRIMARY KEY AUTO_INCREMENT,
  id_cliente INT UNSIGNED NOT NULL,
  id_comercial INT UNSIGNED NOT NULL,
  fecha DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_comercial) REFERENCES comercial(id_comercial)
);
```

### Cambios en campos
- Cambiar `tlf_c` y `tlf_movil` de INT a VARCHAR(15) para soportar 
  formatos internacionales y números con ceros iniciales
- Añadir campo `activo` BOOLEAN en `comercial` para marcar comerciales
  que ya no trabajan en la empresa sin borrar sus datos

### Mejora de relaciones
- Declarar formalmente las FOREIGN KEY entre `auditoria` y `comercial`
- Crear la tabla `pedidos` para conectar `clientes` con `comercial`

## 6. Conclusión personal
La base de datos `ventas` presenta una estructura básica pero incompleta.
Si bien tiene elementos bien diseñados como las claves primarias y la 
restricción UNIQUE del email, le faltan elementos fundamentales como la
tabla de pedidos que da sentido al nombre de la base de datos. Las 
relaciones entre tablas no están formalizadas mediante FOREIGN KEY, lo
que compromete la integridad de los datos. Con las mejoras propuestas,
especialmente la adición de la tabla `pedidos`, la base de datos podría
funcionar correctamente para un sistema de gestión de ventas real.
