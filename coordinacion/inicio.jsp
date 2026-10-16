<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Panel de coordinacion"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT
        (SELECT COUNT(*) FROM ideas WHERE estado = 'Disponible') AS ideas_disp,
        (SELECT COUNT(*) FROM anteproyectos) AS total,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_director IS NULL) AS sin_director,
        (SELECT COUNT(*) FROM anteproyectos WHERE id_evaluador IS NULL) AS sin_evaluador,
        (SELECT COUNT(*) FROM anteproyectos WHERE estado = 'Aprobado por evaluador') AS aprobados
</sql:query>
<c:set var="r" value="${rs.rows[0]}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Panel de coordinacion</h1>
<p class="subtitulo">Bienvenido, <c:out value="${sessionScope.nombre}"/>. Resumen general:</p>

<div class="rejilla-tarjetas">
    <div class="tarjeta">
        <p>Ideas disponibles</p>
        <div class="numero"><c:out value="${r.ideas_disp}"/></div>
    </div>
    <div class="tarjeta">
        <p>Anteproyectos registrados</p>
        <div class="numero"><c:out value="${r.total}"/></div>
    </div>
    <div class="tarjeta">
        <p>Sin director asignado</p>
        <div class="numero"><c:out value="${r.sin_director}"/></div>
    </div>
    <div class="tarjeta">
        <p>Sin evaluador asignado</p>
        <div class="numero"><c:out value="${r.sin_evaluador}"/></div>
    </div>
    <div class="tarjeta">
        <p>Aprobados por evaluador</p>
        <div class="numero"><c:out value="${r.aprobados}"/></div>
    </div>
</div>

<div class="acciones">
    <a class="btn btn-primario" href="${ctx}/coordinacion/ideas.jsp">Gestionar ideas</a>
    <a class="btn btn-secundario" href="${ctx}/coordinacion/buscar-estudiante.jsp">Buscar estudiante</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>