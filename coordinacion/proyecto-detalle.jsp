<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Detalle del proyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.nombres, u.apellidos, u.correo, u.telefono, e.codigo, e.programa,
           a.id_anteproyecto, a.titulo AS titulo_ante, a.resumen, a.archivo, a.estado,
           a.calificacion, a.observaciones_director, a.observaciones_evaluador,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           i.titulo AS idea,
           CONCAT(ud.nombres, ' ', ud.apellidos) AS director, ud.correo AS correo_director, dd.especialidad AS esp_director,
           CONCAT(ue.nombres, ' ', ue.apellidos) AS evaluador, ue.correo AS correo_evaluador, de.especialidad AS esp_evaluador
    FROM estudiantes e
    INNER JOIN usuarios u ON u.id_usuario = e.id_usuario
    LEFT JOIN anteproyectos a ON a.id_estudiante = e.id_usuario
    LEFT JOIN ideas i ON i.id_idea = a.id_idea
    LEFT JOIN usuarios ud ON ud.id_usuario = a.id_director
    LEFT JOIN docentes dd ON dd.id_usuario = a.id_director
    LEFT JOIN usuarios ue ON ue.id_usuario = a.id_evaluador
    LEFT JOIN docentes de ON de.id_usuario = a.id_evaluador
    WHERE e.id_usuario = ?
    <sql:param value="${empty param.id ? 0 : param.id}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/coordinacion/buscar-estudiante.jsp">
        <c:param name="error" value="El estudiante no existe."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<c:set var="documentoExterno" value="${not empty p.archivo and (fn:startsWith(fn:toLowerCase(p.archivo), 'https://') or fn:startsWith(fn:toLowerCase(p.archivo), 'http://'))}"/>
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<section class="revision-hero coordinacion-hero">
    <div>
        <p class="anteproyecto-eyebrow">SEGUIMIENTO DE COORDINACIÓN</p>
        <h1>Proyecto del estudiante</h1>
        <p class="anteproyecto-lead"><c:out value="${p.nombres} ${p.apellidos}"/> · <c:out value="${p.codigo}"/></p>
    </div>
    <div class="revision-hero-acciones">
        <c:choose>
            <c:when test="${empty p.id_anteproyecto}"><span class="badge badge-idea">Sin anteproyecto</span></c:when>
            <c:otherwise><span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span></c:otherwise>
        </c:choose>
        <a class="btn btn-secundario" href="${ctx}/coordinacion/buscar-estudiante.jsp">Volver a búsqueda</a>
    </div>
</section>

<section class="revision-card revision-estudiante">
    <div class="anteproyecto-card-titulo">
        <span class="anteproyecto-icono" aria-hidden="true">01</span>
        <div><h2>Estudiante</h2><p>Información académica y de contacto</p></div>
    </div>
    <div class="revision-estudiante-datos">
        <div><span>Nombre</span><strong><c:out value="${p.nombres} ${p.apellidos}"/></strong></div>
        <div><span>Código</span><strong><c:out value="${p.codigo}"/></strong></div>
        <div><span>Programa</span><strong><c:out value="${p.programa}"/></strong></div>
        <div><span>Correo</span><a href="mailto:<c:out value="${p.correo}"/>"><c:out value="${p.correo}"/></a></div>
    </div>
</section>

<c:choose>
    <c:when test="${empty p.id_anteproyecto}">
        <section class="revision-card coordinacion-vacio">
            <span class="anteproyecto-icono" aria-hidden="true">02</span>
            <div>
                <h2>Aún no hay un anteproyecto</h2>
                <p>El estudiante todavía no ha seleccionado una idea de proyecto. Cuando la elija, aquí aparecerán el avance, el documento y las asignaciones.</p>
            </div>
        </section>
    </c:when>
    <c:otherwise>
        <section class="revision-progreso">
            <div class="revision-progreso-paso <c:if test="${p.estado != 'Idea'}">revision-progreso-completado</c:if><c:if test="${p.estado == 'Idea'}">revision-progreso-actual</c:if>">
                <span>1</span><div><strong>Idea</strong><small>Selección del tema</small></div>
            </div>
            <div class="revision-progreso-paso <c:if test="${p.estado == 'Enviado'}">revision-progreso-actual</c:if><c:if test="${p.estado == 'Aprobado por director' or p.estado == 'Aprobado por evaluador'}">revision-progreso-completado</c:if><c:if test="${p.estado == 'Rechazado'}">revision-progreso-revision</c:if>">
                <span>2</span><div><strong>Director</strong><small>Revisión y calificación</small></div>
            </div>
            <div class="revision-progreso-paso <c:if test="${p.estado == 'Aprobado por director'}">revision-progreso-actual</c:if><c:if test="${p.estado == 'Aprobado por evaluador'}">revision-progreso-completado</c:if>">
                <span>3</span><div><strong>Evaluador</strong><small>Validación final</small></div>
            </div>
            <div class="revision-progreso-paso <c:if test="${p.estado == 'Aprobado por evaluador'}">revision-progreso-completado</c:if>">
                <span>4</span><div><strong>Resultado</strong><small>Cierre de la revisión</small></div>
            </div>
        </section>

        <div class="revision-columnas">
            <div class="coordinacion-columna-principal">
                <section class="revision-card revision-propuesta">
                    <div class="anteproyecto-card-titulo">
                        <span class="anteproyecto-icono" aria-hidden="true">02</span>
                        <div><h2>Anteproyecto</h2><p>Contenido y documento compartido</p></div>
                    </div>
                    <div class="revision-idea"><span>IDEA ELEGIDA</span><strong><c:out value="${p.idea}"/></strong></div>
                    <div class="anteproyecto-dato">
                        <span>Título del anteproyecto</span>
                        <strong><c:out value="${empty p.titulo_ante ? 'Pendiente de completar' : p.titulo_ante}"/></strong>
                    </div>
                    <div class="anteproyecto-dato revision-resumen">
                        <span>Resumen</span>
                        <p><c:out value="${empty p.resumen ? 'Pendiente de completar' : p.resumen}"/></p>
                    </div>
                    <div class="anteproyecto-documento">
                        <div>
                            <span class="documento-etiqueta">DOCUMENTO DEL ANTEPROYECTO</span>
                            <strong><c:choose><c:when test="${empty p.archivo}">Sin documento enlazado</c:when><c:otherwise>Documento disponible para revisión</c:otherwise></c:choose></strong>
                            <small><c:out value="${empty p.fecha_envio ? 'Pendiente de envío' : p.fecha_envio}"/></small>
                        </div>
                        <c:if test="${not empty p.archivo}">
                            <c:choose>
                                <c:when test="${documentoExterno}"><a class="btn btn-secundario btn-sm" href="<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a></c:when>
                                <c:otherwise><a class="btn btn-secundario btn-sm" href="${ctx}/uploads/<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a></c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                </section>

                <section class="revision-card coordinacion-evaluacion">
                    <div class="anteproyecto-card-titulo">
                        <span class="anteproyecto-icono" aria-hidden="true">03</span>
                        <div><h2>Evaluación</h2><p>Calificación y observaciones recibidas</p></div>
                    </div>
                    <div class="coordinacion-calificacion">
                        <span>CALIFICACIÓN DEL DIRECTOR</span>
                        <strong><c:out value="${empty p.calificacion ? 'Pendiente' : p.calificacion}"/><c:if test="${not empty p.calificacion}"><small> / 5.0</small></c:if></strong>
                    </div>
                    <div class="coordinacion-observaciones-grid">
                        <div class="revision-observaciones">
                            <span>OBSERVACIONES DEL DIRECTOR</span>
                            <p><c:out value="${empty p.observaciones_director ? 'Sin observaciones registradas.' : p.observaciones_director}"/></p>
                        </div>
                        <div class="revision-observaciones">
                            <span>OBSERVACIONES DEL EVALUADOR</span>
                            <p><c:out value="${empty p.observaciones_evaluador ? 'Sin observaciones registradas.' : p.observaciones_evaluador}"/></p>
                        </div>
                    </div>
                </section>
            </div>

            <aside class="revision-card coordinacion-asignaciones">
                <div class="anteproyecto-card-titulo">
                    <span class="anteproyecto-icono" aria-hidden="true">04</span>
                    <div><h2>Equipo asignado</h2><p>Docentes responsables de la revisión</p></div>
                </div>
                <article class="persona-asignada">
                    <span class="persona-rol">DIRECTOR</span>
                    <strong><c:out value="${empty p.director ? 'Pendiente de asignación' : p.director}"/></strong>
                    <c:if test="${not empty p.director}">
                        <span><c:out value="${p.esp_director}"/></span>
                        <a href="mailto:<c:out value="${p.correo_director}"/>"><c:out value="${p.correo_director}"/></a>
                    </c:if>
                </article>
                <article class="persona-asignada">
                    <span class="persona-rol">EVALUADOR</span>
                    <strong><c:out value="${empty p.evaluador ? 'Pendiente de asignación' : p.evaluador}"/></strong>
                    <c:if test="${not empty p.evaluador}">
                        <span><c:out value="${p.esp_evaluador}"/></span>
                        <a href="mailto:<c:out value="${p.correo_evaluador}"/>"><c:out value="${p.correo_evaluador}"/></a>
                    </c:if>
                </article>
                <c:if test="${p.estado != 'Aprobado por evaluador'}">
                    <div class="coordinacion-asignar-acciones">
                        <a class="btn btn-primario" href="${ctx}/coordinacion/asignar-director.jsp?id=${p.id_anteproyecto}">
                            <c:out value="${empty p.director ? 'Asignar director' : 'Cambiar director'}"/>
                        </a>
                        <a class="btn btn-secundario" href="${ctx}/coordinacion/asignar-evaluador.jsp?id=${p.id_anteproyecto}">
                            <c:out value="${empty p.evaluador ? 'Asignar evaluador' : 'Cambiar evaluador'}"/>
                        </a>
                    </div>
                </c:if>
            </aside>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
