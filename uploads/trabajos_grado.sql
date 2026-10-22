-- =====================================================
-- BASE DE DATOS: SISTEMA DE TRABAJOS DE GRADO - UTS
-- =====================================================
DROP DATABASE IF EXISTS trabajos_grado;
CREATE DATABASE trabajos_grado CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE trabajos_grado;

-- ---------- ROLES ----------
CREATE TABLE roles (
    id_rol INT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ---------- USUARIOS ----------
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    usuario VARCHAR(30) NOT NULL UNIQUE,
    contrasena VARCHAR(64) NOT NULL,          -- SHA2 (hash)
    id_rol INT NOT NULL,
    estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
) ENGINE=InnoDB;

-- ---------- DATOS PROPIOS DEL ESTUDIANTE ----------
CREATE TABLE estudiantes (
    id_usuario INT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    programa VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------- DATOS PROPIOS DEL DOCENTE (director / evaluador) ----------
CREATE TABLE docentes (
    id_usuario INT PRIMARY KEY,
    especialidad VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------- IDEAS DE ANTEPROYECTO ----------
CREATE TABLE ideas (
    id_idea INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    id_coordinador INT NOT NULL,
    estado ENUM('Disponible','Ocupada') NOT NULL DEFAULT 'Disponible',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_coordinador) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;

-- ---------- ANTEPROYECTOS ----------
CREATE TABLE anteproyectos (
    id_anteproyecto INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL UNIQUE,         -- un anteproyecto por estudiante
    id_idea INT NOT NULL,
    titulo VARCHAR(150),
    resumen TEXT,
    archivo VARCHAR(255),                      -- enlace HTTPS al documento en la nube (tambien admite archivos locales existentes)
    id_director INT NULL,
    id_evaluador INT NULL,
    estado ENUM('Idea','Enviado','Aprobado por director','Aprobado por evaluador','Rechazado')
           NOT NULL DEFAULT 'Idea',
    calificacion DECIMAL(3,1) NULL,
    observaciones_director TEXT,
    observaciones_evaluador TEXT,
    fecha_envio DATETIME NULL,
    fecha_aprob_director DATETIME NULL,
    fecha_aprob_evaluador DATETIME NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_usuario),
    FOREIGN KEY (id_idea) REFERENCES ideas(id_idea),
    FOREIGN KEY (id_director) REFERENCES docentes(id_usuario),      -- RESTRICT: no borrar director con proyectos
    FOREIGN KEY (id_evaluador) REFERENCES docentes(id_usuario)      -- RESTRICT: no borrar evaluador con proyectos
) ENGINE=InnoDB;

-- ---------- CALENDARIO ACADÉMICO ----------
CREATE TABLE calendario_academico (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    descripcion VARCHAR(255),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
) ENGINE=InnoDB;

-- ---------- FORMATOS DE GRADO ----------
CREATE TABLE formatos_grado (
    id_formato INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(255),
    archivo VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- =====================================================
-- DATOS INICIALES
-- =====================================================
INSERT INTO roles VALUES
(1,'Administrador'),
(2,'Coordinacion'),
(3,'Director'),
(4,'Evaluador'),
(5,'Estudiante');

-- Contraseñas: admin = Admin123 | los demás = 123456
INSERT INTO usuarios (id_usuario,nombres,apellidos,documento,correo,telefono,usuario,contrasena,id_rol) VALUES
(1,'Administrador','Sistema','1000000001','admin@uts.edu.co','3000000001','admin',SHA2('Admin123',256),1),
(2,'Laura','Gomez Rios','1000000002','coordinacion@uts.edu.co','3000000002','coordinacion',SHA2('123456',256),2),
(3,'Carlos','Pinto Mejia','1000000003','director@uts.edu.co','3000000003','director',SHA2('123456',256),3),
(4,'Marta','Diaz Lopez','1000000004','evaluador@uts.edu.co','3000000004','evaluador',SHA2('123456',256),4),
(5,'Juan','Perez Soto','1000000005','estudiante@uts.edu.co','3000000005','estudiante',SHA2('123456',256),5);

INSERT INTO docentes VALUES
(3,'Ingenieria de Software'),
(4,'Bases de Datos');

INSERT INTO estudiantes VALUES
(5,'T00012345','Tecnologia en Desarrollo de Sistemas Informaticos');

INSERT INTO ideas (titulo,descripcion,id_coordinador) VALUES
('Sistema de inventario web','Aplicacion web para controlar el inventario de una pequena empresa.',2),
('App de reservas para canchas','Sistema para reservar y administrar canchas deportivas.',2);

INSERT INTO calendario_academico (titulo,descripcion,fecha_inicio,fecha_fin) VALUES
('Entrega de anteproyectos','Fecha limite para subir el anteproyecto','2026-11-02','2026-11-13'),
('Evaluacion de anteproyectos','Revision por director y evaluador','2026-11-16','2026-11-27');

INSERT INTO formatos_grado (nombre,descripcion,archivo) VALUES
('Formato de anteproyecto','Plantilla oficial del anteproyecto','formato_anteproyecto.pdf'),
('Formato de informe final','Plantilla del documento de grado','formato_informe_final.pdf');