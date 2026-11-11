# Base de Datos Bookify

Base de datos relacional para una plataforma de venta de libros, desarrollada en **PostgreSQL** como proyecto práctico de SQL. Modela el catálogo de libros, autores y categorías, junto con la gestión de clientes y pedidos de una tienda online.

## Modelo de datos

La base está organizada en el schema `bookify` y se compone de 8 tablas:

| Tabla | Descripción |
|-------|-------------|
| `categorias` | Categorías de libros (con baja lógica mediante el campo `activa`) |
| `autores` | Datos de autores, con restricción de unicidad por nombre + apellido + fecha de nacimiento |
| `libros` | Catálogo de libros, con precio, stock, páginas e idioma |
| `libros_autores` | Tabla puente para la relación muchos-a-muchos entre libros y autores |
| `clientes` | Datos de clientes, con validación de email por expresión regular |
| `pedidos` | Cabecera de cada pedido, con estados y datos de envío |
| `detalle_pedido` | Líneas de cada pedido (qué libros y en qué cantidad) |

## Relaciones principales

- Un **libro** pertenece a una **categoría** (`ON DELETE SET NULL`: si se borra la categoría, el libro queda sin categoría pero no se elimina).
- Un **libro** puede tener varios **autores** y un autor varios libros, resuelto con la tabla puente `libros_autores` (clave primaria compuesta).
- Un **cliente** puede tener varios **pedidos** (`ON DELETE RESTRICT`: no se puede borrar un cliente con pedidos asociados).
- Un **pedido** se compone de varias líneas en `detalle_pedido`.

## Características técnicas

- **Integridad referencial** con claves foráneas y distintas políticas de borrado (`CASCADE`, `SET NULL`, `RESTRICT`).
- **Restricciones de validación** (`CHECK`): precios y stock no negativos, estados de pedido permitidos, roles de autor válidos.
- **Validación de email** mediante expresión regular.
- **Relación muchos-a-muchos** modelada correctamente con tabla intermedia.
- Campos de auditoría con `TIMESTAMP DEFAULT CURRENT_TIMESTAMP`.

## Tecnología

- PostgreSQL

## Autor

Franco Pasquale
