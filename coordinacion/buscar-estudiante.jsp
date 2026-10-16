<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Buscar estudiante"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.id_usuario, u.nombres, u.apellidos, e.codigo, e.programa, a.estado
    FROM estudiantes e
    INNER JOIN usuarios u ON u.id_usuario = e.id_usuario
    LEFT JOIN anteproyectos a ON a.id_estudiante = e.id_usuario
    WHERE e.codigo LIKE ? OR CONCAT(u.nombres, ' ', u.apellidos) LIKE ?
    ORDER BY u.apellidos, u.nombres
    <sql:param value="%${param.q}%"/>
    <sql:param value="%${param.q}%"/>
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Buscar estudiante</h1>
<p class="subtitulo">Busque por codigo o por nombre para ver su proyecto o anteproyecto.</p>

<form class="buscador" action="${ctx}/coordinacion/buscar-estudiante.jsp" method="get">
    <input type="text" name="q" placeholder="Codigo o nombre del estudiante" value="${fn:escapeXml(param.q)}">
    <button type="submit" class="btn btn-secundario">Buscar</button>
</form>

<p class="subtitulo"><c:out value="${rs.rowCount}"/> estudiante(s) encontrado(s)</p>

<div class="tabla-wrap">
    <table>
        <thead>
            <tr>
                <th>Codigo</th>
                <th>Estudiante</th>
                <th>Programa</th>
                <th>Estado del proyecto</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${rs.rows}">
                <c:set var="est" value="${f.estado}"/>
                <%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>
                <tr>
                    <td><c:out value="${f.codigo}"/></td>
                    <td><c:out value="${f.nombres} ${f.apellidos}"/></td>
                    <td><c:out value="${f.programa}"/></td>
                    <td>
                        <span class="badge ${claseEstado}">
                            <c:out value="${empty f.estado ? 'Sin anteproyecto' : f.estado}"/>
                        </span>
                    </td>
                    <td>
                        <div class="acciones-tabla">
                            <a class="btn btn-secundario btn-sm" href="${ctx}/coordinacion/proyecto-detalle.jsp?id=${f.id_usuario}">Ver proyecto</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${rs.rowCount == 0}">
                <tr><td colspan="5" class="vacio">No se encontraron estudiantes.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>