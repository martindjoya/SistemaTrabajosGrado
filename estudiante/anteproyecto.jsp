<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Mi anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_idea, a.titulo, a.resumen, a.archivo, a.estado,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           CONCAT(ud.nombres, ' ', ud.apellidos) AS director, ud.correo AS correo_director, dd.especialidad AS esp_director,
           CONCAT(ue.nombres, ' ', ue.apellidos) AS evaluador, ue.correo AS correo_evaluador, de.especialidad AS esp_evaluador
    FROM anteproyectos a
    LEFT JOIN usuarios ud ON ud.id_usuario = a.id_director
    LEFT JOIN docentes dd ON dd.id_usuario = a.id_director
    LEFT JOIN usuarios ue ON ue.id_usuario = a.id_evaluador
    LEFT JOIN docentes de ON de.id_usuario = a.id_evaluador
    WHERE a.id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/estudiante/ideas.jsp">
        <c:param name="error" value="Primero debe seleccionar una idea de proyecto."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<sql:query var="idea" dataSource="${bd}">
    SELECT titulo, descripcion
    FROM ideas
    WHERE id_idea = ?
    <sql:param value="${p.id_idea}"/>
</sql:query>
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>
<c:set var="documentoExterno" value="${not empty p.archivo and (fn:startsWith(fn:toLowerCase(p.archivo), 'https://') or fn:startsWith(fn:toLowerCase(p.archivo), 'http://'))}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<section class="anteproyecto-hero">
    <div>
        <p class="anteproyecto-eyebrow">PORTAL DEL ESTUDIANTE</p>
        <h1>Mi anteproyecto</h1>
        <p class="anteproyecto-lead">Consulta tu propuesta, revisa su avance y mantén a mano el enlace al documento.</p>
    </div>
    <span class="badge ${claseEstado} anteproyecto-estado"><c:out value="${p.estado}"/></span>
</section>

<section class="anteproyecto-progreso" aria-label="Progreso de revisión">
    <div class="paso-progreso <c:if test="${p.estado != 'Idea'}">paso-completado</c:if><c:if test="${p.estado == 'Idea'}">paso-actual</c:if>">
        <span class="paso-numero">1</span><div><strong>Propuesta</strong><small>Registro del anteproyecto</small></div>
    </div>
    <div class="paso-progreso <c:if test="${p.estado == 'Enviado'}">paso-actual</c:if><c:if test="${p.estado == 'Aprobado por director' or p.estado == 'Aprobado por evaluador'}">paso-completado</c:if><c:if test="${p.estado == 'Rechazado'}">paso-revision</c:if>">
        <span class="paso-numero">2</span><div><strong>Director</strong><small>Revisión y calificación</small></div>
    </div>
    <div class="paso-progreso <c:if test="${p.estado == 'Aprobado por director'}">paso-actual</c:if><c:if test="${p.estado == 'Aprobado por evaluador'}">paso-completado</c:if>">
        <span class="paso-numero">3</span><div><strong>Evaluador</strong><small>Validación final</small></div>
    </div>
    <div class="paso-progreso <c:if test="${p.estado == 'Aprobado por evaluador'}">paso-completado</c:if>">
        <span class="paso-numero">4</span><div><strong>Resultado</strong><small>Cierre de la revisión</small></div>
    </div>
</section>

<c:if test="${p.estado == 'Rechazado'}">
    <div class="anteproyecto-alerta">
        <strong>Tu propuesta requiere ajustes.</strong> Consulta las observaciones y actualiza el anteproyecto para enviarlo nuevamente.
    </div>
</c:if>

<div class="anteproyecto-columnas">
    <section class="anteproyecto-card anteproyecto-detalle">
        <div class="anteproyecto-card-titulo">
            <span class="anteproyecto-icono" aria-hidden="true">01</span>
            <div><h2>Tu propuesta</h2><p>La idea elegida y el anteproyecto que redactaste se muestran por separado.</p></div>
        </div>
        <div class="idea-original">
            <span class="documento-etiqueta">Datos de la idea seleccionada:</span>
            <h3><c:out value="${idea.rows[0].titulo}"/></h3>
            <p><c:out value="${idea.rows[0].descripcion}"/></p>
        </div>
        <div class="anteproyecto-dato">
            <span>TÍTULO DE ANTEPROYECTO ESCRITO POR TI</span>
            <strong><c:out value="${empty p.titulo ? 'Aún no has escrito el título de tu anteproyecto.' : p.titulo}"/></strong>
        </div>
        <div class="anteproyecto-dato">
            <span>Resumen de tu anteproyecto</span>
            <p><c:out value="${empty p.resumen ? 'Completa los datos de tu anteproyecto para iniciar la revisión.' : p.resumen}"/></p>
        </div>
        <div class="anteproyecto-documento">
            <div>
                <span class="documento-etiqueta">DOCUMENTO DEL ANTEPROYECTO</span>
                <strong><c:choose><c:when test="${empty p.archivo}">Aún no has compartido el documento</c:when><c:otherwise>Enlace al documento en la nube</c:otherwise></c:choose></strong>
                <small>Verifica que el enlace permita el acceso a tu director y evaluador.</small>
            </div>
            <c:if test="${not empty p.archivo}">
                <c:choose>
                    <c:when test="${documentoExterno}">
                        <a class="btn btn-secundario btn-sm" href="<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn btn-secundario btn-sm" href="${ctx}/uploads/<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>
        <div class="anteproyecto-fecha">
            <span>Enviado</span>
            <strong><c:out value="${empty p.fecha_envio ? 'Pendiente de envío' : p.fecha_envio}"/></strong>
        </div>
    </section>

    <aside class="anteproyecto-card anteproyecto-equipo">
        <div class="anteproyecto-card-titulo">
            <span class="anteproyecto-icono" aria-hidden="true">02</span>
            <div><h2>Equipo de revisión</h2><p>Personas asignadas a tu propuesta.</p></div>
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
        <a class="anteproyecto-calificacion" href="${ctx}/estudiante/calificacion.jsp">
            <span>Consulta tu calificación y observaciones</span><strong>Ver evaluación <span aria-hidden="true">&rarr;</span></strong>
        </a>
    </aside>
</div>

<section class="anteproyecto-acciones">
    <div>
        <h2>¿Necesitas actualizar tu propuesta?</h2>
        <p>El sistema habilita las acciones según la etapa en la que se encuentra el anteproyecto.</p>
    </div>
    <div class="acciones">
        <c:choose>
            <c:when test="${p.estado == 'Idea'}">
                <a class="btn btn-primario" href="${ctx}/estudiante/anteproyecto-subir.jsp">Completar anteproyecto</a>
                <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto-eliminar.jsp">Cambiar de idea</a>
            </c:when>
            <c:when test="${p.estado == 'Enviado' or p.estado == 'Rechazado'}">
                <a class="btn btn-primario" href="${ctx}/estudiante/anteproyecto-editar.jsp">Editar anteproyecto</a>
                <a class="btn btn-secundario" href="${ctx}/estudiante/anteproyecto-eliminar.jsp">Eliminar anteproyecto</a>
            </c:when>
            <c:otherwise>
                <p class="anteproyecto-bloqueado">La propuesta ya fue aprobada por el director y no admite cambios.</p>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
