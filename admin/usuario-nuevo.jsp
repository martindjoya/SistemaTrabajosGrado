<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-admin.jspf" %>
<c:set var="titulo" value="Nuevo usuario"/>

<sql:query var="roles" dataSource="${bd}">
    SELECT id_rol, nombre FROM roles WHERE id_rol > 1 ORDER BY id_rol
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Registrar usuario</h1>
<p class="subtitulo">Los campos con * son obligatorios.</p>

<form class="formulario" action="${ctx}/admin/procesar-usuario-nuevo.jsp" method="post">
    <div class="rejilla-2">
        <div class="campo">
            <label for="nombres">Nombres *</label>
            <input type="text" id="nombres" name="nombres" maxlength="80" value="${fn:escapeXml(param.nombres)}" required>
        </div>
        <div class="campo">
            <label for="apellidos">Apellidos *</label>
            <input type="text" id="apellidos" name="apellidos" maxlength="80" value="${fn:escapeXml(param.apellidos)}" required>
        </div>
        <div class="campo">
            <label for="documento">Documento *</label>
            <input type="text" id="documento" name="documento" maxlength="20" value="${fn:escapeXml(param.documento)}" required>
            <div class="ayuda">Solo numeros (5 a 20 digitos).</div>
        </div>
        <div class="campo">
            <label for="telefono">Telefono</label>
            <input type="text" id="telefono" name="telefono" maxlength="15" value="${fn:escapeXml(param.telefono)}">
        </div>
        <div class="campo">
            <label for="correo">Correo electronico *</label>
            <input type="email" id="correo" name="correo" maxlength="100" value="${fn:escapeXml(param.correo)}" required>
        </div>
        <div class="campo">
            <label for="id_rol">Rol *</label>
            <select id="id_rol" name="id_rol" required>
                <option value="">Seleccione...</option>
                <c:forEach var="r" items="${roles.rows}">
                    <option value="${r.id_rol}" ${param.id_rol == r.id_rol ? 'selected' : ''}><c:out value="${r.nombre}"/></option>
                </c:forEach>
            </select>
        </div>
        <div class="campo">
            <label for="usuario">Usuario *</label>
            <input type="text" id="usuario" name="usuario" maxlength="30" value="${fn:escapeXml(param.usuario)}" required>
            <div class="ayuda">4 a 30 caracteres: letras, numeros, punto o guion bajo.</div>
        </div>
        <div class="campo">
            <label for="contrasena">Contrasena *</label>
            <input type="password" id="contrasena" name="contrasena" maxlength="50" required>
            <div class="ayuda">Minimo 6 caracteres.</div>
        </div>
    </div>

    <div class="separador">
        <h3>Solo si el rol es Estudiante</h3>
        <div class="rejilla-2">
            <div class="campo">
                <label for="codigo">Codigo estudiantil</label>
                <input type="text" id="codigo" name="codigo" maxlength="20" value="${fn:escapeXml(param.codigo)}">
            </div>
            <div class="campo">
                <label for="programa">Programa academico</label>
                <input type="text" id="programa" name="programa" maxlength="100" value="${fn:escapeXml(param.programa)}">
            </div>
        </div>
    </div>

    <div class="separador">
        <h3>Solo si el rol es Director o Evaluador</h3>
        <div class="campo">
            <label for="especialidad">Especialidad</label>
            <input type="text" id="especialidad" name="especialidad" maxlength="100" value="${fn:escapeXml(param.especialidad)}">
        </div>
    </div>

    <div class="acciones">
        <button type="submit" class="btn btn-primario">Guardar usuario</button>
        <a class="btn btn-secundario" href="${ctx}/admin/usuarios.jsp">Cancelar</a>
    </div>
</form>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>