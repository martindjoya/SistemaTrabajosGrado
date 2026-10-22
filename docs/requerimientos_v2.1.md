# Especificación de requerimientos: Sistema de Gestión y Seguimiento de Trabajos de Grado

Unidades Tecnológicas de Santander (UTS) – Parcial de Java, segundo corte

Autores: Carol Juliana Carrascal Perez "Lizzy" y Martín David Joya Villamizar

Fecha: 12 de octubre de 2026 | Versión: 2.1

Tecnologías: JSP, JSTL 1.2 (`javax`), JSPF, MySQL/MariaDB (XAMPP) y PostgreSQL (Neon), Tomcat 8.5

## 1. Descripción general

El sistema permite el diseño e implementación de una aplicación web para la gestión y seguimiento de los trabajos de grado de la UTS, desde el anteproyecto hasta la entrega final del documento de grado. Soluciona el almacenamiento, la organización y la búsqueda de la información de los estudiantes y sus trabajos de grado, con acceso diferenciado según el rol del usuario.

Este documento cumple con el objetivo específico del parcial de levantar los requerimientos funcionales (RF) y no funcionales (RNF). Reúne **38 requerimientos funcionales y 30 no funcionales, para un total de 68 requerimientos.** La prioridad se clasifica en Alta, Media o Baja.

## 2. Roles

Según el parcial, el sistema maneja cinco roles. El Administrador es quien crea los usuarios.

| Rol | Responsabilidad |
| --- | --- |
| Administrador | Crea los usuarios (docentes, coordinación y alumnos), y puede ver, editar y eliminar sus datos. |
| Coordinación | Administra las ideas de anteproyecto, agrega director a los anteproyectos aprobados, consulta proyectos de estudiantes y genera informes de estado. |
| Director | Califica los anteproyectos subidos por el alumno y los aprueba para el evaluador. |
| Evaluador | Gestiona los anteproyectos aprobados por el director y los aprueba para los alumnos y la coordinación. |
| Estudiante | Selecciona una idea de proyecto, gestiona su anteproyecto y consulta su calificación. |

## 3. Flujo general del anteproyecto

1. La Coordinación crea las ideas de anteproyecto.
2. El Estudiante selecciona una idea y sube (registra) su anteproyecto.
3. La Coordinación agrega un director al anteproyecto aprobado.
4. El Director califica el anteproyecto y lo aprueba para el evaluador.
5. El Evaluador revisa los anteproyectos aprobados por el director y los aprueba para los alumnos y la Coordinación.
6. El Estudiante consulta la calificación y la Coordinación consulta los informes de estado.

El anteproyecto se registra mediante formularios del sistema, sin carga de archivos.

## 4. Requerimientos funcionales

### 4.1 Generales (todos los roles)

| Código | Requerimiento | Rol | Prioridad |
| --- | --- | --- | --- |
| RF-01 | El sistema debe permitir iniciar sesión con usuario y contraseña, redirigiendo a la vista correspondiente al rol. | Todos | Alta |
| RF-02 | El sistema debe permitir cerrar la sesión de forma segura. | Todos | Alta |
| RF-03 | El sistema debe mostrar un menú de navegación diferente según el rol del usuario. | Todos | Alta |
| RF-04 | El sistema debe permitir consultar el Calendario Académico. | Coordinación, Director, Evaluador y Estudiante | Media |
| RF-05 | El sistema debe permitir consultar los Formatos de Grado. | Coordinación, Director, Evaluador y Estudiante | Media |

### 4.2 Módulo Administrador

| Código | Requerimiento | Rol | Prioridad |
| --- | --- | --- | --- |
| RF-06 | Registrar usuarios docentes, almacenando su información propia y el rol que cumplen (director o evaluador). | Administrador | Alta |
| RF-07 | Registrar usuarios de coordinación, almacenando su información propia. | Administrador | Alta |
| RF-08 | Registrar alumnos, almacenando su información propia (incluido el código estudiantil). | Administrador | Alta |
| RF-09 | Garantizar que la creación de usuarios solo pueda hacerla el Administrador; ningún otro rol puede registrar usuarios. | Administrador | Alta |
| RF-10 | Ver, en una vista, la información de los usuarios de cada rol (docentes, coordinación y alumnos). | Administrador | Alta |
| RF-11 | Editar los datos de un usuario desde la vista de consulta. | Administrador | Alta |
| RF-12 | Eliminar los datos de un usuario desde la vista de consulta. | Administrador | Media |

### 4.3 Módulo Coordinación

| Código | Requerimiento | Rol | Prioridad |
| --- | --- | --- | --- |
| RF-13 | Crear una idea de anteproyecto (CRUD – crear). | Coordinación | Alta |
| RF-14 | Consultar las ideas de anteproyecto creadas (CRUD – consultar). | Coordinación | Alta |
| RF-15 | Editar una idea de anteproyecto (CRUD – editar). | Coordinación | Alta |
| RF-16 | Eliminar una idea de anteproyecto (CRUD – eliminar). | Coordinación | Media |
| RF-17 | Ingresar el código o el nombre de un estudiante para ver los datos del proyecto o anteproyecto que está realizando. | Coordinación | Alta |
| RF-18 | Agregar un director a un anteproyecto aprobado. | Coordinación | Alta |
| RF-19 | Generar el informe del estado del proyecto en alumnos. | Coordinación | Media |
| RF-20 | Generar el informe del estado del proyecto en director. | Coordinación | Media |
| RF-21 | Generar el informe del estado del proyecto en evaluador. | Coordinación | Media |

### 4.4 Módulo Estudiante

| Código | Requerimiento | Rol | Prioridad |
| --- | --- | --- | --- |
| RF-22 | Ver las ideas de proyecto disponibles y seleccionar una. | Estudiante | Alta |
| RF-23 | Registrar su anteproyecto mediante formulario y proporcionar el enlace HTTPS al documento alojado en la nube (CRUD – crear). | Estudiante | Alta |
| RF-24 | Consultar su anteproyecto registrado (CRUD – consultar). | Estudiante | Alta |
| RF-25 | Editar su anteproyecto (CRUD – editar). | Estudiante | Alta |
| RF-26 | Eliminar su anteproyecto (CRUD – eliminar). | Estudiante | Media |
| RF-27 | Mostrar en el CRUD la información del docente director y del evaluador asignados. | Estudiante | Media |
| RF-28 | Consultar el informe con la calificación de su anteproyecto. | Estudiante | Alta |

### 4.5 Módulo Director

| Código | Requerimiento | Rol | Prioridad |
| --- | --- | --- | --- |
| RF-29 | Listar y consultar, en el CRUD, los anteproyectos subidos por los alumnos a su cargo. | Director | Alta |
| RF-30 | Calificar un anteproyecto subido por el alumno (CRUD – registrar calificación). | Director | Alta |
| RF-31 | Modificar la calificación de un anteproyecto (CRUD – editar calificación). | Director | Media |
| RF-32 | Ver en el CRUD la información del alumno autor del anteproyecto. | Director | Media |
| RF-33 | Aprobar un anteproyecto para el evaluador. | Director | Alta |

### 4.6 Módulo Evaluador

| Código | Requerimiento | Rol | Prioridad |
| --- | --- | --- | --- |
| RF-34 | Listar, en el CRUD, los anteproyectos aprobados por el director; no debe mostrar los que aún no tienen esa aprobación. | Evaluador | Alta |
| RF-35 | Consultar el detalle de un anteproyecto aprobado por el director. | Evaluador | Alta |
| RF-36 | Actualizar el estado de evaluación de un anteproyecto (CRUD – editar). | Evaluador | Alta |
| RF-37 | Aprobar un anteproyecto para los alumnos y la Coordinación. | Evaluador | Alta |

### 4.7 Gestión del estado del anteproyecto

| Código | Requerimiento | Rol | Prioridad |
| --- | --- | --- | --- |
| RF-38 | Mantener el estado de cada anteproyecto según su avance (registrado, calificado, aprobado por el director, aprobado por el evaluador) para alimentar los informes de estado. | Sistema | Alta |

## 5. Requerimientos no funcionales

### 5.1 Tecnología y entorno

| Código | Requerimiento | Prioridad |
| --- | --- | --- |
| RNF-01 | Aplicación web desarrollada en Java con páginas JSP. | Alta |
| RNF-02 | Usar JSTL (core, sql y fmt) para la lógica de las vistas: condicionales, ciclos, manejo de parámetros y consultas a la base de datos. | Alta |
| RNF-03 | No usar servlets ni clases DAO; toda la lógica se implementa en JSP con JSTL. | Alta |
| RNF-04 | No usar Maven ni otro gestor de dependencias; las librerías se agregan manualmente en WEB-INF/lib: `jstl-1.2.jar`, el conector de MySQL/MariaDB y el conector de PostgreSQL. No se incluyen JAR de Jakarta (`jakarta.*`), incompatibles con Tomcat 8.5. | Alta |
| RNF-05 | No usar JavaScript; las validaciones se resuelven en el servidor y el diseño solo con HTML y CSS. | Alta |
| RNF-06 | Vistas reutilizables con JSPF (encabezado, menú, pie de página y conexión a la base de datos). | Alta |
| RNF-07 | Base de datos con la misma estructura y datos en dos motores: MySQL/MariaDB local, administrada con XAMPP (phpMyAdmin), y PostgreSQL en la nube (Neon). La aplicación usa uno u otro cambiando solo el archivo de conexión, sin modificar las páginas. | Alta |
| RNF-08 | Ejecución sobre Tomcat 8.5 (el incluido en XAMPP), con el espacio de nombres `javax`; los taglibs de JSTL se declaran con las URI `http://java.sun.com/jsp/jstl/*`. | Alta |
| RNF-09 | Compatibilidad con los navegadores actuales (Chrome, Edge y Firefox). | Media |

### 5.2 Seguridad

| Código | Requerimiento | Prioridad |
| --- | --- | --- |
| RNF-10 | Control de acceso por rol: cada usuario solo accede a las páginas de su perfil. | Alta |
| RNF-11 | Validar la sesión en cada página y redirigir al inicio de sesión cuando no exista. | Alta |
| RNF-12 | Almacenar las contraseñas cifradas (hash) y no en texto plano. | Alta |
| RNF-13 | Prevenir inyección SQL mediante consultas parametrizadas (sql:param). | Alta |
| RNF-14 | Validar en el servidor, con JSTL, los datos de los formularios (campos obligatorios y formatos). | Alta |
| RNF-15 | Imprimir los datos ingresados por los usuarios con escape de caracteres (c:out) para prevenir XSS. | Media |

### 5.3 Usabilidad

| Código | Requerimiento | Prioridad |
| --- | --- | --- |
| RNF-16 | Interfaz clara, intuitiva y con diseño consistente en todos los módulos. | Alta |
| RNF-17 | Diseño adaptable (responsive) a celular, tableta y computador. | Media |
| RNF-18 | Mensajes claros de éxito, error y confirmación (por ejemplo, confirmar antes de eliminar un registro). | Media |
| RNF-19 | Interfaz totalmente en español. | Baja |

### 5.4 Rendimiento

| Código | Requerimiento | Prioridad |
| --- | --- | --- |
| RNF-20 | Soportar varios usuarios conectados de forma simultánea. | Media |
| RNF-21 | Las búsquedas de estudiantes y anteproyectos deben responder en un tiempo razonable (menos de 3 segundos con el volumen de datos del proyecto). | Media |

### 5.5 Calidad, datos y entrega

| Código | Requerimiento | Prioridad |
| --- | --- | --- |
| RNF-22 | Almacenar de forma persistente y organizada la información de los estudiantes y sus trabajos de grado. | Alta |
| RNF-23 | Base de datos normalizada, con llaves primarias y foráneas. | Alta |
| RNF-24 | Garantizar la integridad de los datos (por ejemplo, no eliminar un docente con anteproyectos asignados). | Alta |
| RNF-25 | Código organizado por carpetas (módulos por rol, jspf, css, img) y comentado. | Media |
| RNF-26 | Documentar las historias de usuario y el plan de trabajo del sistema. | Alta |
| RNF-27 | Realizar y documentar pruebas funcionales del software por cada historia de usuario. | Media |
| RNF-28 | Entregar y sustentar el código del sistema. | Alta |

### 5.6 Entorno y despliegue

| Código | Requerimiento | Prioridad |
| --- | --- | --- |
| RNF-29 | El proyecto y su entorno de ejecución (JDK, Tomcat y MariaDB) deben poder llevarse en una unidad portátil (USB) y ejecutarse en otro equipo mediante scripts de inicio y apagado, sin depender de lo instalado en él. | Media |
| RNF-30 | Las credenciales de conexión a las bases de datos (incluida la de Neon) no se suben al repositorio: solo se versionan los archivos `.example`. | Alta |

## 6. Trazabilidad con "Parcial Java Sistema de Informacion Proyecto Segundo Corte.pptx"

| Elemento del PPTX | Requerimientos |
| --- | --- |
| Objetivo: levantar requerimientos funcionales y no funcionales | Todo el documento |
| Objetivo: historias de usuario y plan de trabajo | RNF-26 |
| Objetivo: módulo de gestión desde el anteproyecto hasta el documento de grado | RF-13 a RF-38 |
| Objetivo: almacenamiento, organización y búsqueda de información | RF-10, RF-17, RNF-21, RNF-22 |
| Objetivo: pruebas del software | RNF-27 |
| Rol Administrador | RF-06 a RF-12 |
| Rol Coordinación | RF-13 a RF-21 |
| Rol Estudiante | RF-22 a RF-28 |
| Rol Director | RF-29 a RF-33 |
| Rol Evaluador | RF-34 a RF-37 |
| Calendario Académico y Formatos de Grado | RF-04, RF-05 |
| Entregar y sustentar el código | RNF-28 |

## 7. Historial de cambios

| Versión | Fecha | Cambio |
| --- | --- | --- |
| 2.0 | 11/10/2026 | Versión inicial con 38 RF y 28 RNF |
| 2.1 | 12/10/2026 | Stack `javax` con Tomcat 8.5 y `jstl-1.2` (RNF-04, RNF-08); dos motores de BD idénticos, MariaDB local y PostgreSQL en Neon (RNF-07); nuevos RNF-29 (portabilidad) y RNF-30 (credenciales). Total: 38 RF y 30 RNF |
