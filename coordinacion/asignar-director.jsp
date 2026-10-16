<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Asignar director"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT a.id_anteproyecto, a.id_estudiante, a.id_director, a.estado,
           i.titulo AS idea, e.codigo,
           CONCAT(u.nombres, ' ', u.apellidos) AS estudiante
    FROM anteproyectos a
    INNER JOIN ideas i ON i.id_idea = a.id_idea
    INNER JOIN usuarios u ON u.id_usuario = a.id_estudiante
    INNER JOIN estudiantes e ON e.id_usuario = a.id_estudiante
    WHERE a.id_anteproyecto = ?
    <sql:param value="${empty param.id ? 0 : param.id}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/coordinacion/buscar-estudiante.jsp">
        <c:param name="error" value="El anteproyecto no existe."/>
    </c:redirect>
</c:if>

<c:set var="a" value="${rs.rows[0]}"/>

<c:if test="${a.estado == 'Aprobado por evaluador'}">
    <c:redirect url="/coordinacion/proyecto-detalle.jsp">
        <c:param name="id" value="${a.id_estudiante}"/>
        <c:param name="error" value="El anteproyecto ya fue aprobado y no admite cambios."/>
    </c:redirect>
</c:if>

<sql:query var="docs" dataSource="${bd}">
    SELECT d.id_usuario, CONCAT(u.nombres, ' ', u.apellidos) AS nombre, d.especialidad
    FROM docentes d
    INNER JOIN usuarios u ON u.id_usuario = d.id_usuario
    WHERE u.id_rol = 3 AND u.estado = 'Activo'
    ORDER BY u.apellidos, u.nombres
</sql:query>

<c:set var="sel" value="${pageContext.request.method == 'POST' ? param.id_director : a.id_director}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Asignar director</h1>
<p class="subtitulo">
    Estudiante: <c:out value="${a.estudiante}"/> (<c:out value="${a.codigo}"/>) - Idea: <c:out value="${a.idea}"/>
</p>

<form class="formulario" action="${ctx}/coordinacion/procesar-asignar-director.jsp" method="post">
    <input type="hidden" name="id" value="${a.id_anteproyecto}">

    <div class="campo">
        <label for="id_director">Director *</label>
        <select id="id_director" name="id_director" required>
            <option value="">Seleccione...</option>
            <c:forEach var="r" items="${docs.rows}">
                <option value="${r.id_usuario}" ${sel == r.id_usuario ? 'selected' : ''}>
                    <c:out value="${r.nombre} - ${r.especialidad}"/>
                </option>
            </c:forEach>
        </select>
        <c:if test="${docs.rowCount == 0}">
            <div class="ayuda">No hay directores activos. Registrelos desde el administrador.</div>
        </c:if>
    </div>

    <div class="acciones">
        <button type="submit" class="btn btn-primario">Guardar asignacion</button>
        <a class="btn btn-secundario" href="${ctx}/coordinacion/proyecto-detalle.jsp?id=${a.id_estudiante}">Cancelar</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>