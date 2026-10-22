<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-sesion.jspf" %>
<c:set var="titulo" value="Calendario academico"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT titulo, descripcion, fecha_inicio, fecha_fin
    FROM calendario_academico
    ORDER BY fecha_inicio, fecha_fin
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Calendario academico</h1>
<p class="subtitulo">Fechas importantes del proceso de trabajos de grado.</p>
<p class="acciones">
    <a class="btn btn-primario" href="https://www.uts.edu.co/calendario-academico/" target="_blank" rel="noopener noreferrer">Consultar calendario académico UTS</a>
</p>

<div class="tabla-wrap">
    <table>
        <thead>
            <tr>
                <th>Actividad</th>
                <th>Descripcion</th>
                <th>Inicio</th>
                <th>Fin</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${rs.rows}">
                <tr>
                    <td><strong><c:out value="${f.titulo}"/></strong></td>
                    <td><c:out value="${f.descripcion}"/></td>
                    <td><fmt:formatDate value="${f.fecha_inicio}" pattern="dd/MM/yyyy"/></td>
                    <td><fmt:formatDate value="${f.fecha_fin}" pattern="dd/MM/yyyy"/></td>
                </tr>
            </c:forEach>
            <c:if test="${rs.rowCount == 0}">
                <tr><td colspan="4" class="vacio">No hay fechas registradas.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
