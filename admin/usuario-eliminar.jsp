<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-admin.jspf" %>
<c:set var="titulo" value="Eliminar usuario"/>

<c:if test="${param.id == sessionScope.id_usuario}">
    <c:redirect url="/admin/usuarios.jsp">
        <c:param name="error" value="No puede eliminar su propia cuenta."/>
    </c:redirect>
</c:if>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.id_usuario, u.nombres, u.apellidos, u.documento, u.correo, u.usuario, r.nombre AS rol
    FROM usuarios u
    INNER JOIN roles r ON r.id_rol = u.id_rol
    WHERE u.id_usuario = ?
    <sql:param value="${param.id}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/admin/usuarios.jsp">
        <c:param name="error" value="El usuario no existe."/>
    </c:redirect>
</c:if>

<c:set var="u" value="${rs.rows[0]}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Eliminar usuario</h1>
<p class="subtitulo">Esta accion no se puede deshacer.</p>

<div class="formulario">
    <div class="datos-resumen">
        <p><strong>Nombre:</strong> <c:out value="${u.nombres} ${u.apellidos}"/></p>
        <p><strong>Documento:</strong> <c:out value="${u.documento}"/></p>
        <p><strong>Correo:</strong> <c:out value="${u.correo}"/></p>
        <p><strong>Usuario:</strong> <c:out value="${u.usuario}"/></p>
        <p><strong>Rol:</strong> <c:out value="${u.rol}"/></p>
    </div>

    <form action="${ctx}/admin/procesar-usuario-eliminar.jsp" method="post">
        <input type="hidden" name="id" value="${u.id_usuario}">
        <div class="acciones">
            <button type="submit" class="btn btn-peligro">Si, eliminar</button>
            <a class="btn btn-secundario" href="${ctx}/admin/usuarios.jsp">Cancelar</a>
        </div>
    </form>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>