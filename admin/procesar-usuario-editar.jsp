<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-admin.jspf" %>

<c:if test="${pageContext.request.method != 'POST' or empty param.id}">
    <c:redirect url="/admin/usuarios.jsp"/>
</c:if>

<%-- ===== FORMATOS (REGEXP) ===== --%>
<sql:query var="v" dataSource="${bd}">
    SELECT (? REGEXP '^[0-9]{5,20}$') AS doc_ok,
           (? = '' OR ? REGEXP '^[0-9]{7,15}$') AS tel_ok,
           (? REGEXP '^[^@ ]+@[^@ ]+[.][^@ ]+$') AS cor_ok,
           (? REGEXP '^[A-Za-z0-9_.]{4,30}$') AS usu_ok
    <sql:param value="${fn:trim(param.documento)}"/>
    <sql:param value="${fn:trim(param.telefono)}"/>
    <sql:param value="${fn:trim(param.telefono)}"/>
    <sql:param value="${fn:trim(param.correo)}"/>
    <sql:param value="${fn:trim(param.usuario)}"/>
</sql:query>
<c:set var="f" value="${v.rows[0]}"/>

<%-- ===== VALIDACIONES ===== --%>
<c:set var="msg" value=""/>
<c:choose>
    <c:when test="${empty fn:trim(param.nombres) or empty fn:trim(param.apellidos) or empty fn:trim(param.documento) or empty fn:trim(param.correo) or empty fn:trim(param.usuario) or empty param.id_rol or empty param.estado}">
        <c:set var="msg" value="Complete todos los campos obligatorios."/>
    </c:when>
    <c:when test="${f.doc_ok != 1}">
        <c:set var="msg" value="El documento debe tener solo numeros (5 a 20 digitos)."/>
    </c:when>
    <c:when test="${f.tel_ok != 1}">
        <c:set var="msg" value="El telefono debe tener solo numeros (7 a 15 digitos)."/>
    </c:when>
    <c:when test="${f.cor_ok != 1}">
        <c:set var="msg" value="El correo electronico no es valido."/>
    </c:when>
    <c:when test="${f.usu_ok != 1}">
        <c:set var="msg" value="El usuario debe tener de 4 a 30 caracteres (letras o numeros o punto o guion bajo)."/>
    </c:when>
    <c:when test="${not empty param.contrasena and fn:length(param.contrasena) lt 6}">
        <c:set var="msg" value="La nueva contrasena debe tener minimo 6 caracteres."/>
    </c:when>
    <c:when test="${param.id_rol lt 1 or param.id_rol gt 5}">
        <c:set var="msg" value="Seleccione un rol valido."/>
    </c:when>
    <c:when test="${param.estado != 'Activo' and param.estado != 'Inactivo'}">
        <c:set var="msg" value="Seleccione un estado valido."/>
    </c:when>
    <c:when test="${param.id == sessionScope.id_usuario and (param.id_rol != 1 or param.estado != 'Activo')}">
        <c:set var="msg" value="No puede cambiar su propio rol ni desactivar su propia cuenta."/>
    </c:when>
    <c:when test="${param.id_rol == 5 and (empty fn:trim(param.codigo) or empty fn:trim(param.programa))}">
        <c:set var="msg" value="Para un estudiante el codigo y el programa son obligatorios."/>
    </c:when>
    <c:when test="${(param.id_rol == 3 or param.id_rol == 4) and empty fn:trim(param.especialidad)}">
        <c:set var="msg" value="Para un director o evaluador la especialidad es obligatoria."/>
    </c:when>
</c:choose>

<%-- ===== DUPLICADOS (excluyendo al mismo usuario) ===== --%>
<c:if test="${empty msg}">
    <sql:query var="dup" dataSource="${bd}">
        SELECT COALESCE(SUM(documento = ?), 0) AS n_doc,
               COALESCE(SUM(correo = ?), 0) AS n_cor,
               COALESCE(SUM(usuario = ?), 0) AS n_usu
        FROM usuarios
        WHERE (documento = ? OR correo = ? OR usuario = ?) AND id_usuario <> ?
        <sql:param value="${fn:trim(param.documento)}"/>
        <sql:param value="${fn:trim(param.correo)}"/>
        <sql:param value="${fn:trim(param.usuario)}"/>
        <sql:param value="${fn:trim(param.documento)}"/>
        <sql:param value="${fn:trim(param.correo)}"/>
        <sql:param value="${fn:trim(param.usuario)}"/>
        <sql:param value="${param.id}"/>
    </sql:query>
    <c:choose>
        <c:when test="${dup.rows[0].n_doc > 0}"><c:set var="msg" value="Ya existe otro usuario con ese documento."/></c:when>
        <c:when test="${dup.rows[0].n_cor > 0}"><c:set var="msg" value="Ya existe otro usuario con ese correo."/></c:when>
        <c:when test="${dup.rows[0].n_usu > 0}"><c:set var="msg" value="Ese nombre de usuario ya esta en uso."/></c:when>
    </c:choose>
</c:if>

<c:if test="${empty msg and param.id_rol == 5}">
    <sql:query var="dc" dataSource="${bd}">
        SELECT COUNT(*) AS n FROM estudiantes WHERE codigo = ? AND id_usuario <> ?
        <sql:param value="${fn:trim(param.codigo)}"/>
        <sql:param value="${param.id}"/>
    </sql:query>
    <c:if test="${dc.rows[0].n > 0}">
        <c:set var="msg" value="Ya existe otro estudiante con ese codigo."/>
    </c:if>
</c:if>

<c:if test="${not empty msg}">
    <jsp:forward page="/admin/usuario-editar.jsp">
        <jsp:param name="error" value="${msg}"/>
    </jsp:forward>
</c:if>

<%-- ===== ACTUALIZAR (TRANSACCION) ===== --%>
<c:catch var="err">
    <sql:transaction dataSource="${bd}">
        <sql:update>
            UPDATE usuarios
            SET nombres = ?, apellidos = ?, documento = ?, correo = ?, telefono = ?, usuario = ?,
                contrasena = IF(? = '', contrasena, SHA2(?, 256)),
                id_rol = ?, estado = ?
            WHERE id_usuario = ?
            <sql:param value="${fn:trim(param.nombres)}"/>
            <sql:param value="${fn:trim(param.apellidos)}"/>
            <sql:param value="${fn:trim(param.documento)}"/>
            <sql:param value="${fn:trim(param.correo)}"/>
            <sql:param value="${fn:trim(param.telefono)}"/>
            <sql:param value="${fn:trim(param.usuario)}"/>
            <sql:param value="${param.contrasena}"/>
            <sql:param value="${param.contrasena}"/>
            <sql:param value="${param.id_rol}"/>
            <sql:param value="${param.estado}"/>
            <sql:param value="${param.id}"/>
        </sql:update>

        <c:if test="${param.id_rol != 5}">
            <sql:update>
                DELETE FROM estudiantes WHERE id_usuario = ?
                <sql:param value="${param.id}"/>
            </sql:update>
        </c:if>
        <c:if test="${param.id_rol != 3 and param.id_rol != 4}">
            <sql:update>
                DELETE FROM docentes WHERE id_usuario = ?
                <sql:param value="${param.id}"/>
            </sql:update>
        </c:if>

        <c:if test="${param.id_rol == 5}">
            <sql:update>
                INSERT INTO estudiantes (id_usuario, codigo, programa) VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE codigo = VALUES(codigo), programa = VALUES(programa)
                <sql:param value="${param.id}"/>
                <sql:param value="${fn:trim(param.codigo)}"/>
                <sql:param value="${fn:trim(param.programa)}"/>
            </sql:update>
        </c:if>
        <c:if test="${param.id_rol == 3 or param.id_rol == 4}">
            <sql:update>
                INSERT INTO docentes (id_usuario, especialidad) VALUES (?, ?)
                ON DUPLICATE KEY UPDATE especialidad = VALUES(especialidad)
                <sql:param value="${param.id}"/>
                <sql:param value="${fn:trim(param.especialidad)}"/>
            </sql:update>
        </c:if>
    </sql:transaction>
</c:catch>

<c:if test="${not empty err}">
    <jsp:forward page="/admin/usuario-editar.jsp">
        <jsp:param name="error" value="No se pudo actualizar. Si cambio el rol verifique que el usuario no tenga proyectos asociados."/>
    </jsp:forward>
</c:if>

<c:redirect url="/admin/usuarios.jsp">
    <c:param name="ok" value="Usuario actualizado correctamente."/>
</c:redirect>