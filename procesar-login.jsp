<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>

<c:if test="${pageContext.request.method != 'POST'}">
    <c:redirect url="/login.jsp"/>
</c:if>

<c:if test="${empty param.usuario or empty param.contrasena}">
    <c:redirect url="/login.jsp">
        <c:param name="error" value="Ingrese usuario y contrasena."/>
    </c:redirect>
</c:if>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.id_usuario, u.nombres, u.apellidos, u.id_rol, u.estado, r.nombre AS rol
    FROM usuarios u
    INNER JOIN roles r ON r.id_rol = u.id_rol
    WHERE u.usuario = ? AND u.contrasena = SHA2(?, 256)
    <sql:param value="${param.usuario}"/>
    <sql:param value="${param.contrasena}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/login.jsp">
        <c:param name="error" value="Usuario o contrasena incorrectos."/>
    </c:redirect>
</c:if>

<c:set var="u" value="${rs.rows[0]}"/>

<c:if test="${u.estado != 'Activo'}">
    <c:redirect url="/login.jsp">
        <c:param name="error" value="Su cuenta esta inactiva. Contacte al administrador."/>
    </c:redirect>
</c:if>

<c:set var="id_usuario" value="${u.id_usuario}" scope="session"/>
<c:set var="nombre" value="${u.nombres} ${u.apellidos}" scope="session"/>
<c:set var="id_rol" value="${u.id_rol}" scope="session"/>
<c:set var="rol" value="${u.rol}" scope="session"/>

<%@ include file="/WEB-INF/jspf/redirigir-rol.jspf" %>