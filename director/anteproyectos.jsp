<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-director.jspf" %>
<c:set var="titulo" value="Anteproyectos"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_anteproyecto, e.codigo, CONCAT(u.nombres, ' ', u.apellidos) AS estudiante,
           COALESCE(a.titulo, i.titulo) AS proyecto, a.estado, a.calificacion,
           DATE_FORMAT(a.fecha_envio, '%d/%m/%Y') AS fecha_envio
    FROM anteproyectos a
    INNER JOIN usuarios u ON u.id_usuario = a.id_estudiante
    INNER JOIN estudiantes e ON e.id_usuario = a.id_estudiante
    INNER JOIN ideas i ON i.id_idea = a.id_idea
    WHERE a.id_director = ? AND a.estado <> 'Idea'
      AND (e.codigo LIKE ? OR CONCAT(u.nombres, ' ', u.apellidos) LIKE ?)
      AND (? = '' OR a.estado = ?)
    ORDER BY a.fecha_envio DESC
    <sql:param value="${sessionScope.id_usuario}"/>
    <sql:param value="%${param.q}%"/>
    <sql:param value="%${param.q}%"/>
    <sql:param value="${empty param.estado ? '' : param.estado}"/>
    <sql:param value="${empty param.estado ? '' : param.estado}"/>
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Anteproyectos a mi cargo</h1>

<form class="buscador" action="${ctx}/director/anteproyectos.jsp" method="get">
    <input type="text" name="q" placeholder="Codigo o nombre del estudiante" value="${fn:escapeXml(param.q)}">
    <select name="estado">
        <option value="">Todos los estados</option>
        <option value="Enviado" ${param.estado == 'Enviado' ? 'selected' : ''}>Enviado</option>
        <option value="Aprobado por director" ${param.estado == 'Aprobado por director' ? 'selected' : ''}>Aprobado por director</option>
        <option value="Aprobado por evaluador" ${param.estado == 'Aprobado por evaluador' ? 'selected' : ''}>Aprobado por evaluador</option>
        <option value="Rechazado" ${param.estado == 'Rechazado' ? 'selected' : ''}>Rechazado</option>
    </select>
    <button type="submit" class="btn btn-secundario">Filtrar</button>
</form>

<p class="subtitulo"><c:out value="${rs.rowCount}"/> anteproyecto(s)</p>

<div class="tabla-wrap">
    <table>
        <thead>
            <tr>
                <th>Codigo</th>
                <th>Estudiante</th>
                <th>Proyecto</th>
                <th>Enviado</th>
                <th>Estado</th>
                <th>Nota</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${rs.rows}">
                <c:set var="est" value="${f.estado}"/>
                <%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>
                <tr>
                    <td><c:out value="${f.codigo}"/></td>
                    <td><c:out value="${f.estudiante}"/></td>
                    <td><c:out value="${f.proyecto}"/></td>
                    <td><c:out value="${f.fecha_envio}"/></td>
                    <td><span class="badge ${claseEstado}"><c:out value="${f.estado}"/></span></td>
                    <td><c:out value="${empty f.calificacion ? '-' : f.calificacion}"/></td>
                    <td>
                        <div class="acciones-tabla">
                            <c:choose>
                                <c:when test="${f.estado == 'Enviado'}">
                                    <a class="btn btn-primario btn-sm" href="${ctx}/director/calificar.jsp?id=${f.id_anteproyecto}">Calificar</a>
                                    <c:if test="${not empty f.calificacion}">
                                        <a class="btn btn-secundario btn-sm" href="${ctx}/director/aprobar.jsp?id=${f.id_anteproyecto}">Aprobar</a>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <a class="btn btn-secundario btn-sm" href="${ctx}/director/calificar.jsp?id=${f.id_anteproyecto}">Ver</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${rs.rowCount == 0}">
                <tr><td colspan="7" class="vacio">No tiene anteproyectos para mostrar.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
