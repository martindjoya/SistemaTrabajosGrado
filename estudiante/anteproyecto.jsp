<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Mi anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.titulo, a.resumen, a.archivo, a.estado,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           i.titulo AS idea,
           CONCAT(ud.nombres, ' ', ud.apellidos) AS director, ud.correo AS correo_director, dd.especialidad AS esp_director,
           CONCAT(ue.nombres, ' ', ue.apellidos) AS evaluador, ue.correo AS correo_evaluador, de.especialidad AS esp_evaluador
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
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
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Mi anteproyecto</h1>

<div class="panel">
    <h3>Datos del anteproyecto</h3>
    <dl class="ficha">
        <dt>Idea elegida</dt><dd><c:out value="${p.idea}"/></dd>
        <dt>Estado</dt><dd><span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span></dd>
        <dt>Titulo</dt><dd><c:out value="${empty p.titulo ? 'Pendiente' : p.titulo}"/></dd>
        <dt>Resumen</dt><dd><c:out value="${empty p.resumen ? 'Pendiente' : p.resumen}"/></dd>
        <dt>Documento</dt>
        <dd>
            <c:choose>
                <c:when test="${empty p.archivo}">Aun no ha subido el documento</c:when>
                <c:otherwise>
                    <a href="${ctx}/uploads/<c:out value="${p.archivo}"/>" target="_blank">Ver documento</a>
                </c:otherwise>
            </c:choose>
        </dd>
        <dt>Fecha de envio</dt>
        <dd>
            <c:choose>
                <c:when test="${empty p.fecha_envio}">Aun no enviado</c:when>
                <c:otherwise><c:out value="${p.fecha_envio}"/></c:otherwise>
            </c:choose>
        </dd>
    </dl>
</div>

<div class="panel">
    <h3>Director y evaluador asignados</h3>
    <dl class="ficha">
        <dt>Director</dt>
        <dd>
            <c:choose>
                <c:when test="${empty p.director}">Sin asignar</c:when>
                <c:otherwise><c:out value="${p.director} - ${p.esp_director} - ${p.correo_director}"/></c:otherwise>
            </c:choose>
        </dd>
        <dt>Evaluador</dt>
        <dd>
            <c:choose>
                <c:when test="${empty p.evaluador}">Sin asignar</c:when>
                <c:otherwise><c:out value="${p.evaluador} - ${p.esp_evaluador} - ${p.correo_evaluador}"/></c:otherwise>
            </c:choose>
        </dd>
    </dl>
</div>

<div class="acciones">
    <c:choose>
        <c:when test="${p.estado == 'Idea'}">
            <a class="btn btn-primario" href="${ctx}/estudiante/anteproyecto-subir.jsp">Subir anteproyecto</a>
            <a class="btn btn-peligro" href="${ctx}/estudiante/anteproyecto-eliminar.jsp">Cambiar de idea</a>
        </c:when>
        <c:when test="${p.estado == 'Enviado' or p.estado == 'Rechazado'}">
            <a class="btn btn-primario" href="${ctx}/estudiante/anteproyecto-editar.jsp">Editar</a>
            <a class="btn btn-peligro" href="${ctx}/estudiante/anteproyecto-eliminar.jsp">Eliminar</a>
        </c:when>
        <c:otherwise>
            <p class="subtitulo">El anteproyecto ya fue aprobado por el director y no admite cambios.</p>
        </c:otherwise>
    </c:choose>
    <a class="btn btn-secundario" href="${ctx}/estudiante/calificacion.jsp">Ver calificacion</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
