<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Informe por estudiante"/>

<sql:query var="directores" dataSource="${bd}">
    SELECT u.id_usuario, CONCAT(u.nombres, ' ', u.apellidos) AS nombre
    FROM usuarios u
    INNER JOIN docentes d ON d.id_usuario = u.id_usuario
    WHERE u.id_rol = 3
    ORDER BY u.apellidos, u.nombres
</sql:query>

<sql:query var="evaluadores" dataSource="${bd}">
    SELECT u.id_usuario, CONCAT(u.nombres, ' ', u.apellidos) AS nombre
    FROM usuarios u
    INNER JOIN docentes d ON d.id_usuario = u.id_usuario
    WHERE u.id_rol = 4
    ORDER BY u.apellidos, u.nombres
</sql:query>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.id_usuario, u.nombres, u.apellidos, e.codigo, a.estado, a.calificacion,
           COALESCE(a.titulo, i.titulo) AS proyecto,
           CONCAT(ud.nombres, ' ', ud.apellidos) AS director,
           CONCAT(ue.nombres, ' ', ue.apellidos) AS evaluador
    FROM estudiantes e
    INNER JOIN usuarios u ON u.id_usuario = e.id_usuario
    LEFT JOIN anteproyectos a ON a.id_estudiante = e.id_usuario
    LEFT JOIN ideas i ON i.id_idea = a.id_idea
    LEFT JOIN usuarios ud ON ud.id_usuario = a.id_director
    LEFT JOIN usuarios ue ON ue.id_usuario = a.id_evaluador
    WHERE (e.codigo LIKE ? OR CONCAT(u.nombres, ' ', u.apellidos) LIKE ?)
      AND (? = '' OR a.estado = ?)
      AND (? = '' OR a.id_director = ?)
      AND (? = '' OR a.id_evaluador = ?)
    ORDER BY u.apellidos, u.nombres
    <sql:param value="%${param.q}%"/>
    <sql:param value="%${param.q}%"/>
    <sql:param value="${empty param.estado ? '' : param.estado}"/>
    <sql:param value="${empty param.estado ? '' : param.estado}"/>
    <sql:param value="${empty param.director ? '' : param.director}"/>
    <sql:param value="${empty param.director ? '' : param.director}"/>
    <sql:param value="${empty param.evaluador ? '' : param.evaluador}"/>
    <sql:param value="${empty param.evaluador ? '' : param.evaluador}"/>
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Informe del estado por estudiante</h1>
<p class="subtitulo">Busque y filtre los proyectos por estudiante, director, evaluador o estado.</p>

<form class="buscador" action="${ctx}/coordinacion/informe-estudiante.jsp" method="get">
    <input type="text" name="q" placeholder="Codigo o nombre del estudiante" value="${fn:escapeXml(param.q)}">

    <select name="estado">
        <option value="">Todos los estados</option>
        <option value="Idea" ${param.estado == 'Idea' ? 'selected' : ''}>Idea</option>
        <option value="Enviado" ${param.estado == 'Enviado' ? 'selected' : ''}>Enviado</option>
        <option value="Aprobado por director" ${param.estado == 'Aprobado por director' ? 'selected' : ''}>Aprobado por director</option>
        <option value="Aprobado por evaluador" ${param.estado == 'Aprobado por evaluador' ? 'selected' : ''}>Aprobado por evaluador</option>
        <option value="Rechazado" ${param.estado == 'Rechazado' ? 'selected' : ''}>Rechazado</option>
    </select>

    <select name="director">
        <option value="">Todos los directores</option>
        <c:forEach var="d" items="${directores.rows}">
            <option value="${d.id_usuario}" ${param.director == d.id_usuario ? 'selected' : ''}><c:out value="${d.nombre}"/></option>
        </c:forEach>
    </select>

    <select name="evaluador">
        <option value="">Todos los evaluadores</option>
        <c:forEach var="ev" items="${evaluadores.rows}">
            <option value="${ev.id_usuario}" ${param.evaluador == ev.id_usuario ? 'selected' : ''}><c:out value="${ev.nombre}"/></option>
        </c:forEach>
    </select>

    <button type="submit" class="btn btn-secundario">Filtrar</button>
    <a class="btn btn-secundario" href="${ctx}/coordinacion/informe-estudiante.jsp">Limpiar</a>
</form>

<p class="subtitulo"><c:out value="${rs.rowCount}"/> registro(s)</p>

<div class="tabla-wrap">
    <table>
        <thead>
            <tr>
                <th>Codigo</th>
                <th>Estudiante</th>
                <th>Proyecto</th>
                <th>Estado</th>
                <th>Nota</th>
                <th>Director</th>
                <th>Evaluador</th>
                <th>Detalle</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${rs.rows}">
                <c:set var="est" value="${f.estado}"/>
                <%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>
                <tr>
                    <td><c:out value="${f.codigo}"/></td>
                    <td><c:out value="${f.nombres} ${f.apellidos}"/></td>
                    <td><c:out value="${empty f.proyecto ? 'Sin idea' : f.proyecto}"/></td>
                    <td><span class="badge ${claseEstado}"><c:out value="${empty f.estado ? 'Sin anteproyecto' : f.estado}"/></span></td>
                    <td><c:out value="${empty f.calificacion ? '-' : f.calificacion}"/></td>
                    <td><c:out value="${empty f.director ? 'Sin asignar' : f.director}"/></td>
                    <td><c:out value="${empty f.evaluador ? 'Sin asignar' : f.evaluador}"/></td>
                    <td>
                        <a class="btn btn-secundario btn-sm" href="${ctx}/coordinacion/proyecto-detalle.jsp?id=${f.id_usuario}">Ver</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${rs.rowCount == 0}">
                <tr><td colspan="8" class="vacio">No hay registros para mostrar.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
