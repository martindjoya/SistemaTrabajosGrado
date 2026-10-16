<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<c:remove var="id_usuario" scope="session"/>
<c:remove var="nombre" scope="session"/>
<c:remove var="id_rol" scope="session"/>
<c:remove var="rol" scope="session"/>
<c:redirect url="/login.jsp">
    <c:param name="ok" value="Sesion cerrada correctamente."/>
</c:redirect>