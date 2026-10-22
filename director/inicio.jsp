<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-director.jspf" %>
<c:set var="titulo" value="Panel del director"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT
        (SELECT COUNT(*) FROM anteproyectos WHERE id_director = ? AND estado = 'Enviado') AS por_revisar,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_director = ? AND estado = 'Aprobado por director') AS enviados_evaluador,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_director = ? AND estado = 'Aprobado por evaluador') AS aprobados,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_director = ? AND estado = 'Rechazado') AS rechazados,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_director = ? AND estado <> 'Idea') AS total
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>
<c:set var="r" value="${rs.rows[0]}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Panel del director</h1>
<p class="subtitulo">Bienvenido, <c:out value="${sessionScope.nombre}"/>. Resumen de sus anteproyectos:</p>

<div class="rejilla-tarjetas">
    <div class="tarjeta">
        <p>Por revisar</p>
        <div class="numero"><c:out value="${r.por_revisar}"/></div>
    </div>
    <div class="tarjeta">
        <p>Enviados al evaluador</p>
        <div class="numero"><c:out value="${r.enviados_evaluador}"/></div>
    </div>
    <div class="tarjeta">
        <p>Aprobados por evaluador</p>
        <div class="numero"><c:out value="${r.aprobados}"/></div>
    </div>
    <div class="tarjeta">
        <p>Rechazados</p>
        <div class="numero"><c:out value="${r.rechazados}"/></div>
    </div>
    <div class="tarjeta">
        <p>Total a mi cargo</p>
        <div class="numero"><c:out value="${r.total}"/></div>
    </div>
</div>

<div class="acciones">
    <a class="btn btn-primario" href="${ctx}/director/anteproyectos.jsp">Ver anteproyectos</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
