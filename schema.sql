USE food_store_db;

-- 1. Tabla Categoría
CREATE TABLE categoria (
    id_categoria BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 2. Tabla Cliente
CREATE TABLE cliente (
    id_cliente BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE, -- Restricción UNIQUE para el correo
    telefono VARCHAR(50)
);

-- 3. Tabla Producto
CREATE TABLE producto (
    id_producto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_lista DECIMAL(10, 2) NOT NULL CHECK (precio_lista >= 0), -- CHECK 1: precio no negativo
    stock INT NOT NULL CHECK (stock >= 0), -- CHECK 2: stock no negativo
    activo BOOLEAN NOT NULL DEFAULT TRUE, -- Baja lógica por defecto en verdadero
    id_categoria BIGINT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE RESTRICT
    -- ON DELETE RESTRICT: Impide borrar una categoría si ya tiene productos asignados.
);

-- 4. Tabla Pedido
CREATE TABLE pedido (
    nro_pedido BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    forma_pago ENUM('EFECTIVO', 'TARJETA', 'TRANSFERENCIA') NOT NULL, 
    id_cliente BIGINT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE RESTRICT
    -- ON DELETE RESTRICT: Impide eliminar clientes que tengan un historial de pedidos.
);

-- 5. Tabla Intermedia Detalle_Pedido
CREATE TABLE detalle_pedido (
    nro_pedido BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0), -- CHECK 3: cantidad mayor a cero
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    PRIMARY KEY (nro_pedido, id_producto),
    FOREIGN KEY (nro_pedido) REFERENCES pedido(nro_pedido) ON DELETE CASCADE,
    -- ON DELETE CASCADE: Si se borra un pedido entero, sus líneas de detalle también se borran.
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE RESTRICT
);

-- 6. Creación de Índices
-- Índice para acelerar la búsqueda del historial de pedidos de un cliente específico.
CREATE INDEX idx_pedido_cliente ON pedido(id_cliente);

-- Índice para acelerar el filtrado del catálogo de productos según su categoría.
CREATE INDEX idx_producto_categoria ON producto(id_categoria);