-- ============================================
-- SCRIPT DE CORRECCIÓN - Base de datos Bookify
-- Las tablas ya existen: se modifican con ALTER TABLE
-- ============================================

SET search_path TO bookify, public;

-- --------------------------------------------
-- ERROR 1: CHECK de descuento al revés
-- "BETWEEN 100 AND 0" no admite ningún valor.
-- Hay que borrar el constraint viejo y crear el correcto.
-- --------------------------------------------

-- PostgreSQL le pone nombre automático al CHECK de una columna.
-- Lo más seguro es borrarlo por su nombre probable y recrearlo.
ALTER TABLE detalle_pedido DROP CONSTRAINT IF EXISTS detalle_pedido_descuento_check;

ALTER TABLE detalle_pedido
    ADD CONSTRAINT descuento_valido CHECK (descuento BETWEEN 0 AND 100);


-- --------------------------------------------
-- ERROR 2: faltan las FOREIGN KEY en detalle_pedido
-- Se agregan las relaciones hacia pedidos y libros.
-- --------------------------------------------

ALTER TABLE detalle_pedido
    ADD CONSTRAINT fk_detalle_pedido
    FOREIGN KEY (pedido_id) REFERENCES pedidos (id) ON DELETE CASCADE;

ALTER TABLE detalle_pedido
    ADD CONSTRAINT fk_detalle_libro
    FOREIGN KEY (libro_id) REFERENCES libros (id) ON DELETE RESTRICT;


-- --------------------------------------------
-- ERROR 3: nombres de columnas con errores de tipeo
-- Renombrar columnas NO borra los datos, es seguro.
-- --------------------------------------------

ALTER TABLE libros           RENAME COLUMN asbn       TO isbn;
ALTER TABLE libros           RENAME COLUMN create_ad  TO created_at;
ALTER TABLE categorias       RENAME COLUMN create_at  TO created_at;
ALTER TABLE libros_autores   RENAME COLUMN created_ar TO created_at;
ALTER TABLE pedidos          RENAME COLUMN impuiestos TO impuestos;