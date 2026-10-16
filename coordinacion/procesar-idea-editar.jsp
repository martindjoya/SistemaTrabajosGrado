<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>

<c:if test="${pageContext.request.method != 'POST' or empty param.id}">
    <c:redirect url="/coordinacion/ideas.jsp"/>
</c:if>

<%-- ===== VALIDACIONES ===== --%>
<c:set var="msg" value=""/>
<c:choose>
    <c:when test="${empty fn:trim(param.titulo) or empty fn:trim(param.descripcion) or empty param.estado}">
        <c:set var="msg" value="Complete todos los campos obligatorios."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.titulo)) lt 5 or fn:length(fn:trim(param.titulo)) gt 150}">
        <c:set var="msg" value="El titulo debe tener entre 5 y 150 caracteres."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.descripcion)) lt 10}">
        <c:set var="msg" value="La descripcion debe tener minimo 10 caracteres."/>
    </c:when>
    <c:when test="${param.estado != 'Disponible' and param.estado != 'Ocupada'}">
        <c:set var="msg" value="Seleccione un estado valido."/>
    </c:when>
</c:choose>

<c:if test="${empty msg}">
    <sql:query var="dup" dataSource="${bd}">
        SELECT COUNT(*) AS n FROM ideas WHERE titulo = ? AND id_idea <> ?
        <sql:param value="${fn:trim(param.titulo)}"/>
        <sql:param value="${param.id}"/>
    </sql:query>
    <c:if test="${dup.rows[0].n > 0}">
        <c:set var="msg" value="Ya existe otra idea con ese titulo."/>
    </c:if>
</c:if>

<%-- Una idea tomada por un estudiante no puede volver a Disponible --%>
<c:if test="${empty msg and param.estado == 'Disponible'}">
    <sql:query var="uso" dataSource="${bd}">
        SELECT COUNT(*) AS n FROM anteproyectos WHERE id_idea = ?
        <sql:param value="${param.id}"/>
    </sql:query>
    <c:if test="${uso.rows[0].n > 0}">
        <c:set var="msg" value="La idea esta en uso por un estudiante y no puede quedar Disponible."/>
    </c:if>
</c:if>

<c:if test="${not empty msg}">
    <jsp:forward page="/coordinacion/idea-editar.jsp">
        <jsp:param name="error" value="${msg}"/>
    </jsp:forward>
</c:if>

<%-- ===== ACTUALIZAR ===== --%>
<c:catch var="err">
    <sql:update dataSource="${bd}">
        UPDATE ideas SET titulo = ?, descripcion = ?, estado = ? WHERE id_idea = ?
        <sql:param value="${fn:trim(param.titulo)}"/>
        <sql:param value="${fn:trim(param.descripcion)}"/>
        <sql:param value="${param.estado}"/>
        <sql:param value="${param.id}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty err}">
    <jsp:forward page="/coordinacion/idea-editar.jsp">
        <jsp:param name="error" value="No se pudo actualizar la idea. Intente de nuevo."/>
    </jsp:forward>
</c:if>

<c:redirect url="/coordinacion/ideas.jsp">
    <c:param name="ok" value="Idea actualizada correctamente."/>
</c:redirect>