# Plan de trabajo e historias de usuario

**Proyecto:** Sistema de Gestión y Seguimiento de Trabajos de Grado  
**Periodo:** 16 al 21 de octubre de 2026  
**Sustentación:** 22 de octubre de 2026  
**Objetivo de dedicación:** una hora diaria (seis horas en total)

## Objetivo

Organizar las horas disponibles para preparar una versión demostrable del flujo de trabajos de grado y documentar las historias de usuario que guían su validación. Por el tiempo limitado, el plan prioriza los módulos de Director y Evaluador, actualmente pendientes, y la verificación del flujo completo. La compatibilidad con ambos motores de base de datos y la portabilidad deben reportarse con honestidad si no alcanzan a quedar verificadas.

## Plan diario

| Fecha | Tiempo | Actividad y objetivo de la sesión | Entregable verificable |
| --- | --- | --- | --- |
| Viernes 16 oct. | 1 h | Revisar la aplicación y el esquema; ordenar las historias y confirmar las pantallas y acciones pendientes de Director y Evaluador. | Lista priorizada y entorno local preparado para probar. |
| Sábado 17 oct. | 1 h | Implementar o completar el listado y detalle de anteproyectos del Director, limitado a los proyectos asignados a su usuario. | El Director autenticado ve solo los proyectos a su cargo y puede abrir su detalle. |
| Domingo 18 oct. | 1 h | Implementar o completar el registro/edición de calificación, observaciones y aprobación del Director, con validación de estado. | Un anteproyecto enviado puede calificarse y aprobarse; el cambio de estado queda guardado. |
| Lunes 19 oct. | 1 h | Implementar o completar el listado del Evaluador filtrado por aprobación del Director, el detalle y las acciones de evaluación. | El Evaluador solo ve anteproyectos aprobados por el Director y puede registrar su decisión. |
| Martes 20 oct. | 1 h | Recorrer el flujo como estudiante y coordinación; corregir bloqueos funcionales visibles y comprobar estados e informes relacionados. | Evidencia de una prueba de recorrido desde selección/registro hasta consulta del estado. |
| Miércoles 21 oct. | 1 h | Ejecutar pruebas de aceptación priorizadas, anotar resultados y preparar la demostración y sus limitaciones conocidas. | Lista de pruebas con resultado, datos de demostración y guion breve para la sustentación. |

### Criterio para aprovechar cada hora

Cada sesión comienza con una meta concreta y termina guardando los cambios y anotando el resultado. Si una sesión no alcanza su objetivo, se registra lo pendiente y se prioriza antes de iniciar trabajo secundario. No se debe presentar como verificado un comportamiento que no se haya probado.

## Historias de usuario

### HU-01 — Acceder al sistema según mi rol

**Como** usuario del sistema, **quiero** iniciar y cerrar sesión y ver la navegación correspondiente a mi rol, **para** acceder únicamente a las funciones que me corresponden.  
**Trazabilidad:** RF-01–RF-03, RF-09, RNF-10 y RNF-11.

**Criterios de aceptación**

- Dadas credenciales válidas de una cuenta activa, al iniciar sesión el sistema abre la página de inicio de su rol.
- Con credenciales inválidas o una cuenta inactiva, el acceso se rechaza y se muestra un mensaje comprensible.
- Una solicitud sin sesión se redirige al inicio de sesión; una solicitud a un módulo de otro rol se deniega.
- Al cerrar sesión, la sesión deja de permitir acceso a páginas protegidas.
- El calendario académico y los formatos están disponibles para los roles definidos en los requisitos.

### HU-02 — Administrar usuarios

**Como** Administrador, **quiero** registrar, consultar, editar y eliminar usuarios, **para** mantener las cuentas y los datos propios de estudiantes y docentes.  
**Trazabilidad:** RF-06–RF-12.

**Criterios de aceptación**

- Puedo registrar usuarios de Coordinación, docentes con rol Director o Evaluador y estudiantes con código estudiantil.
- La vista permite consultar y editar los datos de los usuarios.
- Los campos obligatorios y formatos se validan en el servidor; no se aceptan duplicados de identificadores únicos.
- Solo el Administrador puede ejecutar estas operaciones.
- No se permite borrar un usuario que tenga datos relacionados si eso rompe la integridad del sistema; se informa el motivo.

### HU-03 — Gestionar ideas de anteproyecto

**Como** usuario de Coordinación, **quiero** crear, consultar, editar y eliminar ideas de anteproyecto, **para** ofrecer temas disponibles a los estudiantes.  
**Trazabilidad:** RF-13–RF-16.

**Criterios de aceptación**

- Puedo crear una idea con título y descripción obligatorios y verla en el listado.
- Puedo editar una idea existente.
- Puedo eliminar una idea que no esté asociada a un anteproyecto.
- Si una idea está asociada a un anteproyecto, el sistema impide eliminarla y explica por qué.

### HU-04 — Buscar proyectos y administrar asignaciones

**Como** usuario de Coordinación, **quiero** buscar estudiantes y consultar sus proyectos, asignar director y evaluador, **para** acompañar el proceso de cada anteproyecto.  
**Trazabilidad:** RF-17–RF-18.

**Criterios de aceptación**

- Puedo buscar por código o nombre y abrir el detalle del estudiante y su anteproyecto.
- Puedo asignar un usuario activo del rol adecuado como Director o Evaluador.
- El sistema rechaza asignaciones a personas inexistentes, inactivas o con otro rol.
- Las asignaciones quedan guardadas y son visibles en las vistas que correspondan.

### HU-05 — Consultar informes de estado

**Como** usuario de Coordinación, **quiero** consultar el estado de los proyectos por estudiante, Director y Evaluador, **para** dar seguimiento y detectar pendientes.  
**Trazabilidad:** RF-19–RF-21 y RF-38.

**Criterios de aceptación**

- El informe por estudiante identifica el estado actual y muestra las asignaciones y la calificación cuando existan.
- Los informes por Director y Evaluador muestran sus proyectos y el estado de cada uno.
- Los conteos corresponden a los estados guardados en los anteproyectos.

### HU-06 — Seleccionar una idea y registrar mi anteproyecto

**Como** Estudiante, **quiero** ver las ideas disponibles, seleccionar una y registrar los datos de mi anteproyecto, **para** iniciar el proceso de aprobación.  
**Trazabilidad:** RF-22–RF-23.

**Criterios de aceptación**

- Solo puedo seleccionar una idea que esté disponible; la selección la marca como ocupada y queda asociada a mi usuario.
- No puedo seleccionar una segunda idea mientras ya tenga una asignada.
- Puedo registrar título y resumen mediante el formulario del sistema.
- El registro no requiere subir un archivo, de acuerdo con la descripción del flujo en los requisitos.

### HU-07 — Consultar y gestionar mi anteproyecto

**Como** Estudiante, **quiero** consultar, editar o eliminar mi anteproyecto y ver quiénes están asignados, **para** mantener mis datos y conocer el avance.  
**Trazabilidad:** RF-24–RF-27.

**Criterios de aceptación**

- Solo puedo consultar y modificar el anteproyecto asociado a mi cuenta.
- Puedo editar o eliminar el anteproyecto mientras su estado lo permita.
- El sistema muestra el Director, el Evaluador y el estado cuando estén asignados.
- Al eliminar un anteproyecto que aún puede modificarse, la idea vuelve a estar disponible.
- Después de una aprobación que cierre la edición, las acciones de modificación y eliminación se bloquean.

### HU-08 — Consultar la calificación

**Como** Estudiante, **quiero** consultar la calificación, el estado y las observaciones de mi anteproyecto, **para** conocer el resultado de su revisión.  
**Trazabilidad:** RF-28.

**Criterios de aceptación**

- Solo puedo consultar el resultado de mi propio anteproyecto.
- Si aún no existe una calificación, se indica claramente que está pendiente.
- Cuando existen calificación u observaciones, se muestran junto con el estado vigente.

### HU-09 — Revisar y calificar anteproyectos como Director

**Como** Director, **quiero** listar los anteproyectos a mi cargo, consultar los datos del estudiante, registrar o modificar la calificación y aprobar el anteproyecto, **para** remitirlo al Evaluador.  
**Trazabilidad:** RF-29–RF-33.

**Criterios de aceptación**

- Solo aparecen anteproyectos asignados al Director autenticado.
- Puedo consultar el detalle y los datos del estudiante autor.
- Puedo registrar y modificar una calificación válida y observaciones.
- Solo un anteproyecto en estado elegible puede aprobarse; al aprobarlo, su estado y fecha de aprobación se guardan.
- El resultado es visible para el estudiante y para Coordinación.

### HU-10 — Evaluar anteproyectos como Evaluador

**Como** Evaluador, **quiero** consultar los anteproyectos aprobados por el Director y registrar una decisión, **para** completar la etapa de evaluación.  
**Trazabilidad:** RF-34–RF-37.

**Criterios de aceptación**

- El listado excluye cualquier anteproyecto que no haya sido aprobado por el Director.
- Puedo consultar el detalle antes de decidir.
- Puedo actualizar el estado de evaluación y registrar observaciones.
- Al aprobar, el anteproyecto pasa al estado de aprobación del Evaluador y queda disponible para consulta del Estudiante y Coordinación.

## Guion breve de demostración

1. Iniciar sesión como Administrador y mostrar la consulta de usuarios.
2. Iniciar sesión como Coordinación y mostrar ideas, búsqueda e informes.
3. Iniciar sesión como Estudiante y mostrar la selección de idea, el registro del anteproyecto y la consulta del estado.
4. Si las historias HU-09 y HU-10 están implementadas y probadas, completar el recorrido con Director y Evaluador.
5. Indicar explícitamente qué requisitos o pruebas siguen pendientes; no simular aprobaciones si no están persistidas en la base de datos.

## Registro de pruebas para la sustentación

Completar esta tabla durante la sesión del 21 de octubre:

| Historia | Resultado esperado | Resultado observado | Estado / evidencia |
| --- | --- | --- | --- |
| HU-01 | Acceso, redirección por rol y cierre de sesión | | |
| HU-02 | Operación de usuarios y validación de permisos | | |
| HU-03 | CRUD de ideas e integridad de referencias | | |
| HU-04–HU-05 | Búsqueda, asignaciones e informes | | |
| HU-06–HU-08 | Selección, registro y consulta del estudiante | | |
| HU-09 | Listado, calificación y aprobación del Director | | |
| HU-10 | Filtro y decisión del Evaluador | | |

## Guía mínima de Git y GitHub

Git guarda versiones del proyecto en el computador; GitHub guarda una copia remota y facilita compartir cambios. Los términos básicos:

- **Commit:** una captura local de cambios con un mensaje que explica qué se hizo.
- **Push:** publicar commits en GitHub.
- **Pull:** traer a la copia local los cambios publicados.
- **Rama (branch):** una línea de trabajo separada para una tarea.
- **Pull request (PR):** solicitud en GitHub para revisar e integrar una rama en `main`.

### 1. Preparación (una sola vez por computador)

Instalen Git y configuren el nombre y correo que quieran asociar a sus commits:

```powershell
git config --global user.name "Nombre Apellido"
git config --global user.email "correo-asociado-a-GitHub"
```

Este correo identifica los commits; no es la contraseña de GitHub. Para iniciar sesión, sigan la ventana de autenticación de VS Code o del navegador. No escriban contraseñas ni tokens en el código, en el repositorio ni en mensajes de commit.

Si todavía no tienen una copia local, clonen el repositorio una vez:

```powershell
git clone https://github.com/martindjoya/SistemaTrabajosGrado.git
cd SistemaTrabajosGrado
```

Si ya están trabajando dentro de la carpeta del proyecto, no vuelvan a clonarlo.

### 2. Rutina recomendada para cada tarea

Usen una rama por tarea. Reemplacen `mi-tarea` por un nombre corto, por ejemplo `director-calificacion`:

```powershell
git switch main
git pull origin main
git switch -c feature/mi-tarea
```

Realicen y prueben los cambios. Luego revisen qué van a guardar:

```powershell
git status
git diff
```

Agreguen solo los archivos de esa tarea, en vez de agregar ciegamente todo el proyecto:

```powershell
git add "director/archivo-modificado.jsp" "docs/archivo-modificado.md"
git diff --cached
git commit -m "Implementa calificacion del director"
git push -u origin feature/mi-tarea
```

Cambien los nombres de ejemplo por las rutas y la descripción que correspondan. Si `git status` muestra un archivo que no reconocen o que no querían modificar, no lo agreguen; consulten antes con su compañero.

### 3. Abrir y completar un Pull Request

1. En GitHub, abran el repositorio y seleccionen **Compare & pull request** para la rama que acaban de publicar.
2. Confirmen que la rama base sea `main`; escriban qué cambiaron y qué probaron.
3. Revisen el diff juntos. Si está correcto, integren el PR con **Merge pull request**.
4. Después de integrar, cada persona actualiza su copia:

```powershell
git switch main
git pull origin main
```

No empiecen una tarea nueva en una rama antigua: primero actualicen `main` y creen una rama nueva.

### 4. Si Git indica un conflicto

Un conflicto significa que dos cambios tocaron la misma parte de un archivo. No borren cambios para hacer desaparecer el aviso. Abran los archivos señalados, comparen ambas versiones y acuerden cuál resultado conservar; después revisen `git status`, prueben el proyecto y completen el commit. Si no entienden el conflicto, deténganse y pidan ayuda antes de continuar.

Para reducir conflictos, acuerden quién trabaja en cada módulo y eviten editar simultáneamente el mismo archivo. No usen `git push --force`, `git reset --hard` ni descarten cambios de otra persona.

### 5. Antes de publicar cambios

- Revisen `git status` y el diff antes de cada commit.
- No suban contraseñas, tokens, credenciales reales, archivos de configuración privada ni datos personales.
- En este repositorio, `uploads/contraseñas.txt` está actualmente bajo seguimiento de Git. **No lo agreguen ni lo vuelvan a publicar.** Coordinen retirar ese archivo del repositorio y, si alguna contraseña que contiene se utilizó o compartió, cambiarla. Añadirlo a `.gitignore` por sí solo no lo elimina del seguimiento ni del historial; si ya se publicó en GitHub, borrar el archivo en un commit posterior tampoco borra las versiones anteriores. Pidan ayuda al responsable del repositorio para limpiar el historial de forma coordinada.
- No compartan credenciales mediante commits ni mensajes. Para una práctica local, usen cuentas de prueba y datos que no sean reales.
- Si GitHub rechaza el `push` porque alguien publicó primero, no fuercen la subida: actualicen `main`, integren esos cambios en su rama siguiendo la indicación de Git y vuelvan a publicar.

### Comandos útiles para revisar el estado

```powershell
git status
git branch
git log --oneline -5
```

`git status` es el comando más útil para empezar: indica en qué rama están y qué archivos tienen cambios pendientes.
