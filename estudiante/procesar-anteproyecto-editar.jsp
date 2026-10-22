<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>

<c:if test="${pageContext.request.method != 'POST'}">
    <c:redirect url="/estudiante/anteproyecto.jsp"/>
</c:if>

<sql:query var="rs" dataSource="${bd}">
    SELECT id_anteproyecto, estado
    FROM anteproyectos
    WHERE id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>
<c:if test="${rs.rowCount == 0 or (rs.rows[0].estado != 'Enviado' and rs.rows[0].estado != 'Rechazado')}">
    <c:redirect url="/estudiante/anteproyecto.jsp">
        <c:param name="error" value="No es posible editar el anteproyecto en este momento."/>
    </c:redirect>
</c:if>
<c:set var="a" value="${rs.rows[0]}"/>
<c:set var="enlace" value="${fn:trim(param.enlace_documento)}"/>

<c:set var="msg" value=""/>
<c:choose>
    <c:when test="${empty fn:trim(param.titulo) or empty fn:trim(param.resumen) or empty enlace}">
        <c:set var="msg" value="Complete el titulo, el resumen y el enlace al documento."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.titulo)) lt 5 or fn:length(fn:trim(param.titulo)) gt 150}">
        <c:set var="msg" value="El titulo debe tener entre 5 y 150 caracteres."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.resumen)) lt 20}">
        <c:set var="msg" value="El resumen debe tener minimo 20 caracteres."/>
    </c:when>
    <c:when test="${fn:length(enlace) gt 255}">
        <c:set var="msg" value="El enlace no puede superar 255 caracteres."/>
    </c:when>
    <c:when test="${not fn:startsWith(fn:toLowerCase(enlace), 'https://') or fn:length(enlace) le 8 or fn:contains(enlace, ' ')}">
        <c:set var="msg" value="Ingrese un enlace seguro valido que comience por https://."/>
    </c:when>
</c:choose>

<c:if test="${not empty msg}">
    <jsp:forward page="/estudiante/anteproyecto-editar.jsp">
        <jsp:param name="titulo" value="${param.titulo}"/>
        <jsp:param name="resumen" value="${param.resumen}"/>
        <jsp:param name="enlace_documento" value="${enlace}"/>
        <jsp:param name="error" value="${msg}"/>
    </jsp:forward>
</c:if>

<c:catch var="err">
    <sql:update dataSource="${bd}">
        UPDATE anteproyectos
        SET titulo = ?, resumen = ?, archivo = ?, estado = 'Enviado', calificacion = NULL,
            fecha_envio = NOW(), fecha_aprob_director = NULL, fecha_aprob_evaluador = NULL
        WHERE id_anteproyecto = ? AND id_estudiante = ?
          AND estado IN ('Enviado', 'Rechazado')
        <sql:param value="${fn:trim(param.titulo)}"/>
        <sql:param value="${fn:trim(param.resumen)}"/>
        <sql:param value="${enlace}"/>
        <sql:param value="${a.id_anteproyecto}"/>
        <sql:param value="${sessionScope.id_usuario}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty err}">
    <jsp:forward page="/estudiante/anteproyecto-editar.jsp">
        <jsp:param name="titulo" value="${param.titulo}"/>
        <jsp:param name="resumen" value="${param.resumen}"/>
        <jsp:param name="enlace_documento" value="${enlace}"/>
        <jsp:param name="error" value="No se pudo actualizar el anteproyecto. Intente de nuevo."/>
    </jsp:forward>
</c:if>

<c:redirect url="/estudiante/anteproyecto.jsp">
    <c:param name="ok" value="Anteproyecto actualizado correctamente."/>
</c:redirect>
