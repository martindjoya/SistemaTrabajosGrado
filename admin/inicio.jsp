<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-admin.jspf" %>
<c:set var="titulo" value="Panel del administrador"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT r.nombre, COUNT(u.id_usuario) AS total
    FROM roles r
    LEFT JOIN usuarios u ON u.id_rol = r.id_rol
    GROUP BY r.id_rol, r.nombre
    ORDER BY r.id_rol
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Panel del administrador</h1>
<p class="subtitulo">Bienvenido, <c:out value="${sessionScope.nombre}"/>. Usuarios registrados por rol:</p>

<div class="rejilla-tarjetas">
    <c:forEach var="f" items="${rs.rows}">
        <div class="tarjeta">
            <p><c:out value="${f.nombre}"/></p>
            <div class="numero"><c:out value="${f.total}"/></div>
        </div>
    </c:forEach>
</div>

<div class="acciones">
    <a class="btn btn-primario" href="${ctx}/admin/usuarios.jsp">Ver usuarios</a>
    <a class="btn btn-secundario" href="${ctx}/admin/usuario-nuevo.jsp">Registrar usuario</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>