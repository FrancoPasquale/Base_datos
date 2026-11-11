CREATE SCHEMA bookify;
SET search_path TO bookify, public;

CREATE TABLE categorias (
id SERIAL PRIMARY KEY,
nombre VARCHAR(50) NOT NULL UNIQUE,
descripcion TEXT,
activa BOOLEAN DEFAULT TRUE,
create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE autores(
id SERIAL PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
apellido VARCHAR(100),
nacionalidad VARCHAR(50),
fecha_nacimiento DATE,
biografia TEXT,
create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT gente_unica UNIQUE (nombre,apellido,fecha_nacimiento)
);

CREATE TABLE libros(
id SERIAL PRIMARY KEY,
titulo VARCHAR(200) NOT NULL,
asbn VARCHAR(13) NOT NULL,
precio DECIMAL(10,2) NOT NULL CHECK (precio>=0),
stock INTEGER DEFAULT 0 CHECK (stock >=0),
paginas INTEGER CHECK (paginas>=0),
idioma VARCHAR(50) DEFAULT 'Español',
fecha_publicacion DATE,
categoria_id INTEGER,
CONSTRAINT categoria_id FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE SET NULL,
create_ad TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE libros_autores(
libro_id INTEGER NOT NULL,
autor_id INTEGER NOT NULL,
rol VARCHAR(50) DEFAULT 'Autor',
created_ar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT libro_id FOREIGN KEY (libro_id) REFERENCES libros (id) ON DELETE CASCADE,
CONSTRAINT autor_id FOREIGN KEY (autor_id) REFERENCES autores (id) ON DELETE CASCADE,
CONSTRAINT roles_validos CHECK (rol IN ('Autor','Coautor','Editor','Traductor','Ilustrador')),
PRIMARY KEY (libro_id,autor_id)
);
CREATE TABLE clientes(
id SERIAL PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
apellidos VARCHAR(100) NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
telefono VARCHAR(20),
direccion TEXT,
ciudad VARCHAR(100),
codigo_postal VARCHAR(10),
pais VARCHAR(50) DEFAULT 'España',
fecha_registro DATE DEFAULT CURRENT_DATE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT mail_valido CHECK (email ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$')
);
CREATE TABLE pedidos(
id SERIAL PRIMARY KEY,
numero_pedido VARCHAR(20) UNIQUE,
cliente_id INTEGER NOT NULL,
fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
estado VARCHAR(20) DEFAULT 'pendiente',
direccion_envio VARCHAR(100)NOT NULL,
ciudad_envio VARCHAR(100) NOT NULL,
codigo_postal_envio VARCHAR(50),
pais_envio VARCHAR(100) DEFAULT 'España',
importe DECIMAL(10,2) CHECK (importe >=0),
subtotal DECIMAL(10,2) DEFAULT 0,
impuiestos DECIMAL(10,2) DEFAULT 0,
gastos_envio DECIMAL(10,2) DEFAULT 0,
total DECIMAL(10,2) DEFAULT 0,
nota TEXT,
fecha_envio TIMESTAMP,
fecha_entrega TIMESTAMP,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT estado_valido CHECK (estado IN ('pendiente','confirmado','procesado','enviado','entregado','cancelado')),
CONSTRAINT cliente_id FOREIGN KEY (cliente_id) REFERENCES clientes (id) ON DELETE RESTRICT
);

CREATE TABLE detalle_pedido(
id SERIAL PRIMARY KEY,
pedido_id INTEGER NOT NULL,
libro_id INTEGER NOT NULL,
cantidad INTEGER NOT NULL CHECK (cantidad >0),
precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario>=0),
descuento DECIMAL(5,2) DEFAULT 0 CHECK (descuento BETWEEN 100 AND 0),
subtotal_linea DECIMAL(10,2) NOT NULL CHECK(subtotal_linea>=0),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT libros_unicos_en_pedido UNIQUE (pedido_id,libro_id) 
);
