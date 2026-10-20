<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-evaluador.jspf" %>
<c:set var="titulo" value="Revisar anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_anteproyecto, a.titulo AS titulo_ante, a.resumen, a.archivo, a.estado,
           a.calificacion, a.observaciones_director, a.observaciones_evaluador,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y %H:%i') AS fecha_envio,
           DATE_FORMAT(a.fecha_aprob_director, '%d/%m/%Y %H:%i') AS fecha_aprob_director,
           DATE_FORMAT(a.fecha_aprob_evaluador, '%d/%m/%Y %H:%i') AS fecha_aprob_evaluador,
           i.titulo AS idea,
           u.nombres, u.apellidos, u.correo, e.codigo, e.programa,
           CONCAT(ud.nombres, ' ', ud.apellidos) AS director
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
    INNER JOIN usuarios u ON u.id_usuario = a.id_estudiante
    INNER JOIN estudiantes e ON e.id_usuario = a.id_estudiante
    LEFT JOIN usuarios ud ON ud.id_usuario = a.id_director
    WHERE a.id_anteproyecto = ? AND a.id_evaluador = ?
      AND a.estado IN ('Aprobado por director', 'Aprobado por evaluador', 'Rechazado')
    <sql:param value="${empty param.id ? 0 : param.id}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/evaluador/anteproyectos.jsp">
        <c:param name="error" value="El anteproyecto no existe o no esta a su cargo."/>
    </c:redirect>
</c:if>

<c:set var="p" value="${rs.rows[0]}"/>
<c:set var="est" value="${p.estado}"/>
<%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<div class="barra-superior">
    <h1>Revisar anteproyecto</h1>
    <a class="btn btn-secundario" href="${ctx}/evaluador/anteproyectos.jsp">Volver al listado</a>
</div>

<div class="panel">
    <h3>Datos del estudiante</h3>
    <dl class="ficha">
        <dt>Nombre</dt><dd><c:out value="${p.nombres} ${p.apellidos}"/></dd>
        <dt>Codigo</dt><dd><c:out value="${p.codigo}"/></dd>
        <dt>Programa</dt><dd><c:out value="${p.programa}"/></dd>
        <dt>Correo</dt><dd><c:out value="${p.correo}"/></dd>
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
                <c:when test="${empty p.archivo}">Sin archivo</c:when>
                <c:otherwise><a href="${ctx}/uploads/<c:out value="${p.archivo}"/>" target="_blank">Descargar documento</a></c:otherwise>
            </c:choose>
        </dd>
        <dt>Estado</dt><dd><span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span></dd>
        <dt>Fecha de envio</dt><dd><c:out value="${p.fecha_envio}"/></dd>
    </dl>
</div>

<div class="panel">
    <h3>Revision del director</h3>
    <dl class="ficha">
        <dt>Director</dt><dd><c:out value="${empty p.director ? 'Sin asignar' : p.director}"/></dd>
        <dt>Nota</dt><dd><c:out value="${empty p.calificacion ? '-' : p.calificacion}"/></dd>
        <dt>Observaciones</dt><dd><c:out value="${empty p.observaciones_director ? 'Sin observaciones' : p.observaciones_director}"/></dd>
        <dt>Aprobado el</dt><dd><c:out value="${empty p.fecha_aprob_director ? 'Pendiente' : p.fecha_aprob_director}"/></dd>
    </dl>
</div>

<c:choose>
    <c:when test="${p.estado == 'Aprobado por director'}">
        <form class="formulario" method="post">
            <h3>Decision del evaluador</h3>
            <input type="hidden" name="id" value="${p.id_anteproyecto}">

            <div class="campo">
                <label for="observaciones">Observaciones</label>
                <textarea id="observaciones" name="observaciones">${fn:escapeXml(param.observaciones)}</textarea>
                <div class="ayuda">Opcionales al aprobar. Obligatorias al rechazar (minimo 10 caracteres).</div>
            </div>

            <div class="acciones">
                <button type="submit" class="btn btn-primario" formaction="${ctx}/evaluador/procesar-aprobar.jsp">Aprobar anteproyecto</button>
                <button type="submit" class="btn btn-peligro" formaction="${ctx}/evaluador/procesar-rechazar.jsp">Rechazar anteproyecto</button>
            </div>
        </form>
    </c:when>
    <c:otherwise>
        <div class="panel">
            <h3>Decision registrada</h3>
            <dl class="ficha">
                <dt>Resultado</dt><dd><span class="badge ${claseEstado}"><c:out value="${p.estado}"/></span></dd>
                <dt>Observaciones</dt><dd><c:out value="${empty p.observaciones_evaluador ? 'Sin observaciones' : p.observaciones_evaluador}"/></dd>
                <c:if test="${not empty p.fecha_aprob_evaluador}">
                    <dt>Aprobado el</dt><dd><c:out value="${p.fecha_aprob_evaluador}"/></dd>
                </c:if>
            </dl>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
