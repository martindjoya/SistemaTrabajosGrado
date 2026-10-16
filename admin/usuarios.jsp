<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-admin.jspf" %>
<c:set var="titulo" value="Usuarios"/>

<sql:query var="roles" dataSource="${bd}">
    SELECT id_rol, nombre FROM roles ORDER BY id_rol
</sql:query>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.id_usuario, u.nombres, u.apellidos, u.documento, u.correo, u.usuario, u.estado, r.nombre AS rol
    FROM usuarios u
    INNER JOIN roles r ON r.id_rol = u.id_rol
    WHERE (CONCAT(u.nombres, ' ', u.apellidos) LIKE ? OR u.documento LIKE ? OR u.usuario LIKE ?)
      AND (? = '' OR u.id_rol = ?)
    ORDER BY u.id_usuario DESC
    <sql:param value="%${param.q}%"/>
    <sql:param value="%${param.q}%"/>
    <sql:param value="%${param.q}%"/>
    <sql:param value="${empty param.rol ? '' : param.rol}"/>
    <sql:param value="${empty param.rol ? '' : param.rol}"/>
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<div class="barra-superior">
    <h1>Usuarios</h1>
    <a class="btn btn-primario" href="${ctx}/admin/usuario-nuevo.jsp">Nuevo usuario</a>
</div>

<form class="buscador" action="${ctx}/admin/usuarios.jsp" method="get">
    <input type="text" name="q" placeholder="Buscar por nombre, documento o usuario" value="${fn:escapeXml(param.q)}">
    <select name="rol">
        <option value="">Todos los roles</option>
        <c:forEach var="r" items="${roles.rows}">
            <option value="${r.id_rol}" ${param.rol == r.id_rol ? 'selected' : ''}><c:out value="${r.nombre}"/></option>
        </c:forEach>
    </select>
    <button type="submit" class="btn btn-secundario">Buscar</button>
</form>

<p class="subtitulo"><c:out value="${rs.rowCount}"/> usuario(s) encontrado(s)</p>

<div class="tabla-wrap">
    <table>
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Documento</th>
                <th>Correo</th>
                <th>Usuario</th>
                <th>Rol</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${rs.rows}">
                <tr>
                    <td><c:out value="${f.nombres} ${f.apellidos}"/></td>
                    <td><c:out value="${f.documento}"/></td>
                    <td><c:out value="${f.correo}"/></td>
                    <td><c:out value="${f.usuario}"/></td>
                    <td><c:out value="${f.rol}"/></td>
                    <td>
                        <span class="badge ${f.estado == 'Activo' ? 'badge-activo' : 'badge-inactivo'}">
                            <c:out value="${f.estado}"/>
                        </span>
                    </td>
                    <td>
                        <div class="acciones-tabla">
                            <a class="btn btn-secundario btn-sm" href="${ctx}/admin/usuario-editar.jsp?id=${f.id_usuario}">Editar</a>
                            <c:if test="${f.id_usuario != sessionScope.id_usuario}">
                                <a class="btn btn-peligro btn-sm" href="${ctx}/admin/usuario-eliminar.jsp?id=${f.id_usuario}">Eliminar</a>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${rs.rowCount == 0}">
                <tr><td colspan="7" class="vacio">No se encontraron usuarios.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>