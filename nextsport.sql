-- Eliminar la base de datos si existe y crear una nueva
DROP DATABASE IF EXISTS NextSport;
CREATE DATABASE NextSport;
USE NextSport;

-- Tabla de clientes (usuarios del sistema)
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    ultima_sesion DATETIME,
    CONSTRAINT chk_correo CHECK (correo LIKE '%@%.%')
);

-- Tabla de proveedores (dueños de canchas)
CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de canchas
CREATE TABLE canchas (
    id_cancha INT AUTO_INCREMENT PRIMARY KEY,
    id_proveedor INT NOT NULL,
    nombre_cancha VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(255) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    material ENUM('césped natural', 'césped sintético', 'cemento', 'arcilla', 'madera') NOT NULL,
    tamano VARCHAR(50) NOT NULL, -- Ejemplo: '5x5', '11x11'
    capacidad_jugadores INT NOT NULL,
    techada BOOLEAN DEFAULT FALSE,
    iluminacion BOOLEAN DEFAULT FALSE,
    estado ENUM('disponible', 'en mantenimiento', 'inactiva') DEFAULT 'disponible',
    descripcion TEXT,
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor) ON DELETE CASCADE
);

-- Tabla de horarios disponibles para cada cancha
CREATE TABLE horarios_disponibles (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    id_cancha INT NOT NULL,
    dia_semana ENUM('lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_cancha) REFERENCES canchas(id_cancha) ON DELETE CASCADE,
    CONSTRAINT chk_hora CHECK (hora_inicio < hora_fin)
);

-- Tabla de reservas
CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_cancha INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado ENUM('pendiente', 'confirmada', 'cancelada', 'completada') DEFAULT 'pendiente',
    monto_total DECIMAL(10,2) NOT NULL,
    fecha_reserva DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_cancha) REFERENCES canchas(id_cancha) ON DELETE CASCADE,
    CONSTRAINT chk_horas_reserva CHECK (hora_inicio < hora_fin)
);

-- Tabla de pagos
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_cliente INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'otro') NOT NULL,
    estado_pago ENUM('pendiente', 'completado', 'reembolsado') DEFAULT 'pendiente',
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    referencia VARCHAR(100),
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Tabla de servicios adicionales
CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    disponible BOOLEAN DEFAULT TRUE
);

-- Relación entre reservas y servicios adicionales
CREATE TABLE reserva_servicios (
    id_reserva INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_reserva, id_servicio),
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio) ON DELETE CASCADE
);

-- Tabla de calificaciones
CREATE TABLE calificaciones (
    id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_cliente INT NOT NULL,
    puntuacion INT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha_calificacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Tabla de promociones
CREATE TABLE promociones (
    id_promocion INT AUTO_INCREMENT PRIMARY KEY,
    id_cancha INT,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    descuento DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    codigo VARCHAR(50) UNIQUE,
    activa BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_cancha) REFERENCES canchas(id_cancha) ON DELETE SET NULL,
    CONSTRAINT chk_fechas CHECK (fecha_inicio <= fecha_fin)
);



