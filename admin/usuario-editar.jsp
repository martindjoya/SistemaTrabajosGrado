<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-admin.jspf" %>
<c:set var="titulo" value="Editar usuario"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT u.*, e.codigo, e.programa, d.especialidad
    FROM usuarios u
    LEFT JOIN estudiantes e ON e.id_usuario = u.id_usuario
    LEFT JOIN docentes d ON d.id_usuario = u.id_usuario
    WHERE u.id_usuario = ?
    <sql:param value="${param.id}"/>
</sql:query>

<c:if test="${rs.rowCount == 0}">
    <c:redirect url="/admin/usuarios.jsp">
        <c:param name="error" value="El usuario no existe."/>
    </c:redirect>
</c:if>

<sql:query var="roles" dataSource="${bd}">
    SELECT id_rol, nombre FROM roles ORDER BY id_rol
</sql:query>

<%-- Si viene de un POST con error se muestran los datos enviados; si no, los de la base --%>
<c:set var="u" value="${rs.rows[0]}"/>
<c:set var="d" value="${pageContext.request.method == 'POST' ? param : u}"/>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Editar usuario</h1>
<p class="subtitulo">Deje la contrasena vacia si no desea cambiarla.</p>

<form class="formulario" action="${ctx}/admin/procesar-usuario-editar.jsp" method="post">
    <input type="hidden" name="id" value="${u.id_usuario}">

    <div class="rejilla-2">
        <div class="campo">
            <label for="nombres">Nombres *</label>
            <input type="text" id="nombres" name="nombres" maxlength="80" value="${fn:escapeXml(d.nombres)}" required>
        </div>
        <div class="campo">
            <label for="apellidos">Apellidos *</label>
            <input type="text" id="apellidos" name="apellidos" maxlength="80" value="${fn:escapeXml(d.apellidos)}" required>
        </div>
        <div class="campo">
            <label for="documento">Documento *</label>
            <input type="text" id="documento" name="documento" maxlength="20" value="${fn:escapeXml(d.documento)}" required>
        </div>
        <div class="campo">
            <label for="telefono">Telefono</label>
            <input type="text" id="telefono" name="telefono" maxlength="15" value="${fn:escapeXml(d.telefono)}">
        </div>
        <div class="campo">
            <label for="correo">Correo electronico *</label>
            <input type="email" id="correo" name="correo" maxlength="100" value="${fn:escapeXml(d.correo)}" required>
        </div>
        <div class="campo">
            <label for="usuario">Usuario *</label>
            <input type="text" id="usuario" name="usuario" maxlength="30" value="${fn:escapeXml(d.usuario)}" required>
        </div>
        <div class="campo">
            <label for="id_rol">Rol *</label>
            <select id="id_rol" name="id_rol" required>
                <c:forEach var="r" items="${roles.rows}">
                    <option value="${r.id_rol}" ${d.id_rol == r.id_rol ? 'selected' : ''}><c:out value="${r.nombre}"/></option>
                </c:forEach>
            </select>
        </div>
        <div class="campo">
            <label for="estado">Estado *</label>
            <select id="estado" name="estado" required>
                <option value="Activo" ${d.estado == 'Activo' ? 'selected' : ''}>Activo</option>
                <option value="Inactivo" ${d.estado == 'Inactivo' ? 'selected' : ''}>Inactivo</option>
            </select>
        </div>
        <div class="campo">
            <label for="contrasena">Nueva contrasena</label>
            <input type="password" id="contrasena" name="contrasena" maxlength="50">
            <div class="ayuda">Minimo 6 caracteres.</div>
        </div>
    </div>

    <div class="separador">
        <h3>Solo si el rol es Estudiante</h3>
        <div class="rejilla-2">
            <div class="campo">
                <label for="codigo">Codigo estudiantil</label>
                <input type="text" id="codigo" name="codigo" maxlength="20" value="${fn:escapeXml(d.codigo)}">
            </div>
            <div class="campo">
                <label for="programa">Programa academico</label>
                <input type="text" id="programa" name="programa" maxlength="100" value="${fn:escapeXml(d.programa)}">
            </div>
        </div>
    </div>

    <div class="separador">
        <h3>Solo si el rol es Director o Evaluador</h3>
        <div class="campo">
            <label for="especialidad">Especialidad</label>
            <input type="text" id="especialidad" name="especialidad" maxlength="100" value="${fn:escapeXml(d.especialidad)}">
        </div>
    </div>

    <div class="acciones">
        <button type="submit" class="btn btn-primario">Guardar cambios</button>
        <a class="btn btn-secundario" href="${ctx}/admin/usuarios.jsp">Cancelar</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>