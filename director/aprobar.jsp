<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-director.jspf" %>
<c:set var="titulo" value="Aprobar anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_anteproyecto, a.titulo AS titulo_ante, a.resumen, a.archivo,
           a.calificacion, a.observaciones_director,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           i.titulo AS idea,
           u.nombres, u.apellidos, e.codigo, e.programa
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
    INNER JOIN usuarios u ON u.id_usuario = a.id_estudiante
    INNER JOIN estudiantes e ON e.id_usuario = a.id_estudiante
    WHERE a.id_anteproyecto = ? AND a.id_director = ? AND a.estado = 'Enviado'
    <sql:param value="${empty param.id ? 0 : param.id}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/director/anteproyectos.jsp">
        <c:param name="error" value="El anteproyecto no existe, no esta a su cargo o ya no puede aprobarse."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<c:set var="documentoExterno" value="${not empty p.archivo and (fn:startsWith(fn:toLowerCase(p.archivo), 'https://') or fn:startsWith(fn:toLowerCase(p.archivo), 'http://'))}"/>
<c:if test="${empty p.calificacion}">
    <c:redirect url="/director/calificar.jsp">
        <c:param name="id" value="${p.id_anteproyecto}"/>
        <c:param name="error" value="Registre la calificacion antes de aprobar el anteproyecto."/>
    </c:redirect>
</c:if>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<div class="barra-superior">
    <h1>Aprobar anteproyecto</h1>
    <a class="btn btn-secundario" href="${ctx}/director/anteproyectos.jsp">Volver al listado</a>
</div>

<div class="panel">
    <h3>Datos del estudiante</h3>
    <dl class="ficha">
        <dt>Nombre</dt><dd><c:out value="${p.nombres} ${p.apellidos}"/></dd>
        <dt>Codigo</dt><dd><c:out value="${p.codigo}"/></dd>
        <dt>Programa</dt><dd><c:out value="${p.programa}"/></dd>
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
        <dt>Fecha de envio</dt><dd><c:out value="${p.fecha_envio}"/></dd>
        <dt>Calificacion</dt><dd><c:out value="${p.calificacion}"/> / 5.0</dd>
        <dt>Observaciones</dt><dd><c:out value="${p.observaciones_director}"/></dd>
    </dl>
</div>

<form class="formulario" action="${ctx}/director/procesar-aprobar.jsp" method="post">
    <input type="hidden" name="id" value="${p.id_anteproyecto}">
    <p>Al aprobarlo, el anteproyecto sera enviado al evaluador y ya no podra editarse desde su cuenta.</p>
    <div class="acciones">
        <button type="submit" class="btn btn-primario">Confirmar aprobacion</button>
        <a class="btn btn-secundario" href="${ctx}/director/calificar.jsp?id=${p.id_anteproyecto}">Volver a la calificacion</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>