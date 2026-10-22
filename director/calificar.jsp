<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-director.jspf" %>
<c:set var="titulo" value="Calificar anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_anteproyecto, a.titulo AS titulo_ante, a.resumen, a.archivo, a.estado,
           a.calificacion, a.observaciones_director, a.observaciones_evaluador,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           i.titulo AS idea,
           u.nombres, u.apellidos, u.correo, u.telefono, e.codigo, e.programa
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
    INNER JOIN usuarios u ON u.id_usuario = a.id_estudiante
    INNER JOIN estudiantes e ON e.id_usuario = a.id_estudiante
    WHERE a.id_anteproyecto = ? AND a.id_director = ? AND a.estado <> 'Idea'
    <sql:param value="${empty param.id ? 0 : param.id}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/director/anteproyectos.jsp">
        <c:param name="error" value="El anteproyecto no existe o no esta a su cargo."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<c:set var="documentoExterno" value="${fn:startsWith(fn:toLowerCase(p.archivo), 'https://') or fn:startsWith(fn:toLowerCase(p.archivo), 'http://')}"/>
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>
<c:set var="d" value="${pageContext.request.method == 'POST' ? param : p}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<div class="barra-superior">
    <h1>Calificar anteproyecto</h1>
    <a class="btn btn-secundario" href="${ctx}/director/anteproyectos.jsp">Volver al listado</a>
</div>

<div class="panel">
    <h3>Datos del estudiante</h3>
    <dl class="ficha">
        <dt>Nombre</dt><dd><c:out value="${p.nombres} ${p.apellidos}"/></dd>
        <dt>Codigo</dt><dd><c:out value="${p.codigo}"/></dd>
        <dt>Programa</dt><dd><c:out value="${p.programa}"/></dd>
        <dt>Correo</dt><dd><c:out value="${p.correo}"/></dd>
        <dt>Telefono</dt><dd><c:out value="${empty p.telefono ? 'No registrado' : p.telefono}"/></dd>
    </dl>
</div>

<div class="panel">
    <h3>Anteproyecto</h3>
    <dl class="ficha">
        <dt>Idea elegida</dt><dd><c:out value="${p.idea}"/></dd>
        <dt>Titulo</dt><dd><c:out value="${p.titulo_ante}"/></dd>
        <dt>Resumen</dt><dd><c:out value="${p.resumen}"/></dd>
        <dt>Documento</dt>
        <dd>
            <c:choose>
                <c:when test="${empty p.archivo}">Sin documento enlazado</c:when>
                <c:when test="${documentoExterno}"><a href="<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento en la nube</a></c:when>
                <c:otherwise><a href="${ctx}/uploads/<c:out value="${p.archivo}"/>" target="_blank" rel="noopener noreferrer">Abrir documento</a></c:otherwise>
            </c:choose>
        </dd>
        <dt>Estado</dt><dd><span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span></dd>
        <dt>Fecha de envio</dt><dd><c:out value="${p.fecha_envio}"/></dd>
        <c:if test="${not empty p.observaciones_evaluador}">
            <dt>Observaciones del evaluador</dt><dd><c:out value="${p.observaciones_evaluador}"/></dd>
        </c:if>
    </dl>
</div>

<c:choose>
    <c:when test="${p.estado == 'Enviado'}">
        <form class="formulario" action="${ctx}/director/procesar-calificar.jsp" method="post">
            <h3>Calificacion</h3>
            <input type="hidden" name="id" value="${p.id_anteproyecto}">

            <div class="campo">
                <label for="calificacion">Nota (0.0 a 5.0) *</label>
                <input type="number" id="calificacion" name="calificacion" min="0" max="5" step="0.1"
                       value="${fn:escapeXml(d.calificacion)}" required>
            </div>
            <div class="campo">
                <label for="observaciones">Observaciones *</label>
                <textarea id="observaciones" name="observaciones" required>${fn:escapeXml(d.observaciones_director)}</textarea>
                <div class="ayuda">Minimo 10 caracteres.</div>
            </div>

            <div class="acciones">
                <button type="submit" class="btn btn-primario">Guardar calificacion</button>
                <c:if test="${not empty p.calificacion}">
                    <a class="btn btn-secundario" href="${ctx}/director/aprobar.jsp?id=${p.id_anteproyecto}">Ir a aprobar</a>
                </c:if>
            </div>
        </form>
    </c:when>
    <c:otherwise>
        <div class="panel">
            <h3>Calificacion registrada</h3>
            <dl class="ficha">
                <dt>Nota</dt><dd><c:out value="${empty p.calificacion ? '-' : p.calificacion}"/></dd>
                <dt>Observaciones</dt><dd><c:out value="${empty p.observaciones_director ? 'Sin observaciones' : p.observaciones_director}"/></dd>
            </dl>
            <p class="subtitulo">Este anteproyecto ya no admite cambios de su parte.</p>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
