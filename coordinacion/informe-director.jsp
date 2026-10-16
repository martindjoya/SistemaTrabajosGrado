<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Informe por director"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.id_usuario, CONCAT(u.nombres, ' ', u.apellidos) AS nombre, d.especialidad,
           COUNT(a.id_anteproyecto) AS total,
           COALESCE(SUM(a.estado = 'Idea'), 0) AS n_idea,
           COALESCE(SUM(a.estado = 'Enviado'), 0) AS n_enviado,
           COALESCE(SUM(a.estado = 'Aprobado por director'), 0) AS n_director,
           COALESCE(SUM(a.estado = 'Aprobado por evaluador'), 0) AS n_evaluador,
           COALESCE(SUM(a.estado = 'Rechazado'), 0) AS n_rechazado
    FROM usuarios u
    INNER JOIN docentes d ON d.id_usuario = u.id_usuario
    LEFT JOIN anteproyectos a ON a.id_director = u.id_usuario
    WHERE u.id_rol = 3
    GROUP BY u.id_usuario, u.nombres, u.apellidos, d.especialidad
    ORDER BY u.apellidos, u.nombres
</sql:query>

<c:if test="${not empty param.id}">
    <sql:query var="det" dataSource="${bd}">
        SELECT a.id_anteproyecto, e.codigo, CONCAT(ue.nombres, ' ', ue.apellidos) AS estudiante,
               COALESCE(a.titulo, i.titulo) AS proyecto, a.estado, a.calificacion, a.id_estudiante
        FROM anteproyectos a
        INNER JOIN usuarios ue ON ue.id_usuario = a.id_estudiante
        INNER JOIN estudiantes e ON e.id_usuario = a.id_estudiante
        INNER JOIN ideas i ON i.id_idea = a.id_idea
        WHERE a.id_director = ?
        ORDER BY a.id_anteproyecto DESC
        <sql:param value="${param.id}"/>
    </sql:query>
</c:if>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Informe del estado por director</h1>
<p class="subtitulo">Cantidad de anteproyectos a cargo de cada director segun su estado.</p>

<div class="tabla-wrap">
    <table>
        <thead>
            <tr>
                <th>Director</th>
                <th>Especialidad</th>
                <th>Total</th>
                <th>Idea</th>
                <th>Enviados</th>
                <th>Aprob. director</th>
                <th>Aprob. evaluador</th>
                <th>Rechazados</th>
                <th>Detalle</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${rs.rows}">
                <tr>
                    <td><c:out value="${f.nombre}"/></td>
                    <td><c:out value="${f.especialidad}"/></td>
                    <td><strong><c:out value="${f.total}"/></strong></td>
                    <td><c:out value="${f.n_idea}"/></td>
                    <td><c:out value="${f.n_enviado}"/></td>
                    <td><c:out value="${f.n_director}"/></td>
                    <td><c:out value="${f.n_evaluador}"/></td>
                    <td><c:out value="${f.n_rechazado}"/></td>
                    <td>
                        <a class="btn btn-secundario btn-sm" href="${ctx}/coordinacion/informe-director.jsp?id=${f.id_usuario}">Ver</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${rs.rowCount == 0}">
                <tr><td colspan="9" class="vacio">No hay directores registrados.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<c:if test="${not empty param.id}">
    <div class="separador">
        <h2>Proyectos del director seleccionado</h2>
        <div class="tabla-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Codigo</th>
                        <th>Estudiante</th>
                        <th>Proyecto</th>
                        <th>Estado</th>
                        <th>Nota</th>
                        <th>Detalle</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="f" items="${det.rows}">
                        <c:set var="est" value="${f.estado}"/>
                        <%@ include file="/WEB-INF/jspf/clase-estado.jspf" %>
                        <tr>
                            <td><c:out value="${f.codigo}"/></td>
                            <td><c:out value="${f.estudiante}"/></td>
                            <td><c:out value="${f.proyecto}"/></td>
                            <td><span class="badge ${claseEstado}"><c:out value="${f.estado}"/></span></td>
                            <td><c:out value="${empty f.calificacion ? '-' : f.calificacion}"/></td>
                            <td>
                                <a class="btn btn-secundario btn-sm" href="${ctx}/coordinacion/proyecto-detalle.jsp?id=${f.id_estudiante}">Ver</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${det.rowCount == 0}">
                        <tr><td colspan="6" class="vacio">Este director no tiene proyectos asignados.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>