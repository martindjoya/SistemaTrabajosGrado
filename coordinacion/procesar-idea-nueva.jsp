<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>

<c:if test="${pageContext.request.method != 'POST'}">
    <c:redirect url="/coordinacion/ideas.jsp"/>
</c:if>

<%-- ===== VALIDACIONES ===== --%>
<c:set var="msg" value=""/>
<c:choose>
    <c:when test="${empty fn:trim(param.titulo) or empty fn:trim(param.descripcion)}">
        <c:set var="msg" value="Complete todos los campos obligatorios."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.titulo)) lt 5 or fn:length(fn:trim(param.titulo)) gt 150}">
        <c:set var="msg" value="El titulo debe tener entre 5 y 150 caracteres."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.descripcion)) lt 10}">
        <c:set var="msg" value="La descripcion debe tener minimo 10 caracteres."/>
    </c:when>
</c:choose>

<c:if test="${empty msg}">
    <sql:query var="dup" dataSource="${bd}">
        SELECT COUNT(*) AS n FROM ideas WHERE titulo = ?
        <sql:param value="${fn:trim(param.titulo)}"/>
    </sql:query>
    <c:if test="${dup.rows[0].n > 0}">
        <c:set var="msg" value="Ya existe una idea con ese titulo."/>
    </c:if>
</c:if>

<c:if test="${not empty msg}">
    <jsp:forward page="/coordinacion/idea-nueva.jsp">
        <jsp:param name="error" value="${msg}"/>
    </jsp:forward>
</c:if>

<%-- ===== GUARDAR ===== --%>
<c:catch var="err">
    <sql:update dataSource="${bd}">
        INSERT INTO ideas (titulo, descripcion, id_coordinador) VALUES (?, ?, ?)
        <sql:param value="${fn:trim(param.titulo)}"/>
        <sql:param value="${fn:trim(param.descripcion)}"/>
        <sql:param value="${sessionScope.id_usuario}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty err}">
    <jsp:forward page="/coordinacion/idea-nueva.jsp">
        <jsp:param name="error" value="No se pudo guardar la idea. Intente de nuevo."/>
    </jsp:forward>
</c:if>

<c:redirect url="/coordinacion/ideas.jsp">
    <c:param name="ok" value="Idea registrada correctamente."/>
</c:redirect>