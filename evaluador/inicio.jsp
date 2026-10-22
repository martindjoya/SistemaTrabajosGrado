<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-evaluador.jspf" %>
<c:set var="titulo" value="Panel del evaluador"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT
        (SELECT COUNT(*) FROM anteproyectos WHERE id_evaluador = ? AND estado = 'Aprobado por director') AS por_revisar,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_evaluador = ? AND estado = 'Aprobado por evaluador') AS aprobados,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_evaluador = ? AND estado = 'Rechazado') AS rechazados,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_evaluador = ? AND estado = 'Enviado') AS pendientes_director,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_evaluador = ? AND estado IN ('Enviado','Aprobado por director','Aprobado por evaluador','Rechazado')) AS total
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>
<c:set var="r" value="${rs.rows[0]}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Panel del evaluador</h1>
<p class="subtitulo">Bienvenido, <c:out value="${sessionScope.nombre}"/>. Resumen de sus anteproyectos:</p>

<div class="rejilla-tarjetas">
    <div class="tarjeta">
        <p>En revisión del director</p>
        <div class="numero"><c:out value="${r.pendientes_director}"/></div>
    </div>
    <div class="tarjeta">
        <p>Por revisar</p>
        <div class="numero"><c:out value="${r.por_revisar}"/></div>
    </div>
    <div class="tarjeta">
        <p>Aprobados</p>
        <div class="numero"><c:out value="${r.aprobados}"/></div>
    </div>
    <div class="tarjeta">
        <p>Rechazados</p>
        <div class="numero"><c:out value="${r.rechazados}"/></div>
    </div>
    <div class="tarjeta">
        <p>Total recibidos</p>
        <div class="numero"><c:out value="${r.total}"/></div>
    </div>
</div>

<div class="acciones">
    <a class="btn btn-primario" href="${ctx}/evaluador/anteproyectos.jsp">Ver anteproyectos</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
