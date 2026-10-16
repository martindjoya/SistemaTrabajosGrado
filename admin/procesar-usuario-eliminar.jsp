<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-admin.jspf" %>

<c:if test="${pageContext.request.method != 'POST' or empty param.id}">
    <c:redirect url="/admin/usuarios.jsp"/>
</c:if>

<c:if test="${param.id == sessionScope.id_usuario}">
    <c:redirect url="/admin/usuarios.jsp">
        <c:param name="error" value="No puede eliminar su propia cuenta."/>
    </c:redirect>
</c:if>

<c:catch var="err">
    <sql:update dataSource="${bd}">
        DELETE FROM usuarios WHERE id_usuario = ?
        <sql:param value="${param.id}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty err}">
    <c:redirect url="/admin/usuarios.jsp">
        <c:param name="error" value="No se puede eliminar: el usuario tiene ideas o anteproyectos asociados."/>
    </c:redirect>
</c:if>

<c:redirect url="/admin/usuarios.jsp">
    <c:param name="ok" value="Usuario eliminado correctamente."/>
</c:redirect>