<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>

<c:if test="${pageContext.request.method != 'POST' or empty param.id}">
    <c:redirect url="/coordinacion/buscar-estudiante.jsp"/>
</c:if>

<sql:query var="ap" dataSource="${bd}">
    SELECT id_estudiante, estado FROM anteproyectos WHERE id_anteproyecto = ?
    <sql:param value="${param.id}"/>
</sql:query>

<c:if test="${ap.rowCount == 0}">
    <c:redirect url="/coordinacion/buscar-estudiante.jsp">
        <c:param name="error" value="El anteproyecto no existe."/>
    </c:redirect>
</c:if>
<c:set var="a" value="${ap.rows[0]}"/>

<%-- ===== VALIDACIONES ===== --%>
<c:set var="msg" value=""/>
<c:choose>
    <c:when test="${empty param.id_evaluador}">
        <c:set var="msg" value="Seleccione un evaluador."/>
    </c:when>
    <c:when test="${a.estado == 'Aprobado por evaluador'}">
        <c:set var="msg" value="El anteproyecto ya fue aprobado y no admite cambios."/>
    </c:when>
</c:choose>

<c:if test="${empty msg}">
    <sql:query var="ok" dataSource="${bd}">
        SELECT COUNT(*) AS n
        FROM docentes d
        INNER JOIN usuarios u ON u.id_usuario = d.id_usuario
        WHERE d.id_usuario = ? AND u.id_rol = 4 AND u.estado = 'Activo'
        <sql:param value="${param.id_evaluador}"/>
    </sql:query>
    <c:if test="${ok.rows[0].n == 0}">
        <c:set var="msg" value="El evaluador seleccionado no es valido."/>
    </c:if>
</c:if>

<c:if test="${not empty msg}">
    <jsp:forward page="/coordinacion/asignar-evaluador.jsp">
        <jsp:param name="error" value="${msg}"/>
    </jsp:forward>
</c:if>

<%-- ===== GUARDAR ===== --%>
<c:catch var="err">
    <sql:update dataSource="${bd}">
        UPDATE anteproyectos SET id_evaluador = ? WHERE id_anteproyecto = ?
        <sql:param value="${param.id_evaluador}"/>
        <sql:param value="${param.id}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty err}">
    <jsp:forward page="/coordinacion/asignar-evaluador.jsp">
        <jsp:param name="error" value="No se pudo asignar el evaluador. Intente de nuevo."/>
    </jsp:forward>
</c:if>

<c:redirect url="/coordinacion/proyecto-detalle.jsp">
    <c:param name="id" value="${a.id_estudiante}"/>
    <c:param name="ok" value="Evaluador asignado correctamente."/>
</c:redirect>